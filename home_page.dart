import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/video_api.dart';
import '../models/video_model.dart';
import '../widgets/video_card.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<VideoModel> _videos = [];
  bool _loading = false;
  int _page = 1;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadData() async {
    if (_loading) return;
    setState(() => _loading = true);

    try {
      final result = await VideoApi.getVideoList(page: _page);
      if (result['code'] == 1) {
        final List<VideoModel> newVideos = (result['list'] as List)
            .map((item) => VideoModel.fromJson(item))
            .toList();
        setState(() {
          _videos.addAll(newVideos);
          _page++;
        });
      }
    } catch (e) {
      print('加载数据错误: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('视频列表'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _videos.clear();
            _page = 1;
          });
          await _loadData();
        },
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(8),
          itemCount: _videos.length + 1,
          itemBuilder: (context, index) {
            if (index == _videos.length) {
              return _loading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox();
            }
            return VideoCard(
              video: _videos[index],
              onTap: () => Get.to(() => DetailPage(video: _videos[index])),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
