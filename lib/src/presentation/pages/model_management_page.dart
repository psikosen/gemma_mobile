import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/models/ai_model.dart';
import '../bloc/models/model_bloc.dart';
import '../widgets/download_progress_indicator.dart';

class ModelManagementPage extends StatefulWidget {
  const ModelManagementPage({Key? key}) : super(key: key);

  @override
  State<ModelManagementPage> createState() => _ModelManagementPageState();
}

class _ModelManagementPageState extends State<ModelManagementPage> {
  final List<AIModel> _availableModels = [
    AIModel(
      id: 'gemma-2b-it',
      name: 'Gemma 2B-IT',
      description: 'Lightweight generative AI model from Google',
      downloadUrl: 'https://huggingface.co/google/gemma-2b-it',
      size: '1.2 GB',
      localPath: '',
      isDownloaded: false,
      isDownloading: false,
      downloadProgress: 0.0,
    ),
    AIModel(
      id: 'gemma3-1b-it',
      name: 'Gemma3 1B-IT',
      description: 'Compact version of Gemma 3 from Litert-community',
      downloadUrl: 'https://huggingface.co/litert-community/Gemma3-1B-IT',
      size: '0.9 GB',
      localPath: '',
      isDownloaded: false,
      isDownloading: false,
      downloadProgress: 0.0,
    ),
    AIModel(
      id: 'deepseek-r1',
      name: 'DeepSeek R1 Distill Qwen 1.5B',
      description: 'High-quality distilled LLM from DeepSeek',
      downloadUrl: 'https://huggingface.co/litert-community/DeepSeek-R1-Distill-Qwen-1.5B',
      size: '1.5 GB',
      localPath: '',
      isDownloaded: false,
      isDownloading: false,
      downloadProgress: 0.0,
    ),
    AIModel(
      id: 'phi-4-mini',
      name: 'Phi-4 Mini Instruct',
      description: 'Compact yet powerful LLM from Microsoft',
      downloadUrl: 'https://huggingface.co/litert-community/Phi-4-mini-instruct',
      size: '0.8 GB',
      localPath: '',
      isDownloaded: false,
      isDownloading: false,
      downloadProgress: 0.0,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _checkDownloadedModels();
  }

  Future<void> _checkDownloadedModels() async {
    final modelsDir = await _getModelsDirectory();
    
    setState(() {
      for (var i = 0; i < _availableModels.length; i++) {
        final modelPath = '${modelsDir.path}/${_availableModels[i].id}';
        final modelDir = Directory(modelPath);
        
        if (modelDir.existsSync()) {
          _availableModels[i] = _availableModels[i].copyWith(
            isDownloaded: true,
            localPath: modelPath,
          );
        }
      }
    });
  }

  Future<Directory> _getModelsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final modelsDir = Directory('${appDir.path}/ai_models');
    
    if (!modelsDir.existsSync()) {
      await modelsDir.create(recursive: true);
    }
    
    return modelsDir;
  }

  Future<void> _downloadModel(AIModel model) async {
    try {
      setState(() {
        final modelIndex = _availableModels.indexWhere((m) => m.id == model.id);
        _availableModels[modelIndex] = _availableModels[modelIndex].copyWith(
          isDownloading: true,
          downloadProgress: 0.0,
        );
      });

      // Example of how to download a model - in a real implementation,
      // you'd use a more robust method to download the model files
      final modelsDir = await _getModelsDirectory();
      final modelDir = Directory('${modelsDir.path}/${model.id}');
      
      if (!modelDir.existsSync()) {
        await modelDir.create(recursive: true);
      }

      // Here we would actually implement the download logic
      // For a real implementation, you would use:
      // 1. The HuggingFace API to get download links
      // 2. A download manager to handle large file downloads
      // 3. Proper error handling and retry logic
      
      // Simulating download progress
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() {
          final modelIndex = _availableModels.indexWhere((m) => m.id == model.id);
          _availableModels[modelIndex] = _availableModels[modelIndex].copyWith(
            downloadProgress: i / 10,
          );
        });
      }

      // Mark as downloaded
      setState(() {
        final modelIndex = _availableModels.indexWhere((m) => m.id == model.id);
        _availableModels[modelIndex] = _availableModels[modelIndex].copyWith(
          isDownloaded: true,
          isDownloading: false,
          downloadProgress: 1.0,
          localPath: modelDir.path,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${model.name} downloaded successfully')),
      );
    } catch (error) {
      setState(() {
        final modelIndex = _availableModels.indexWhere((m) => m.id == model.id);
        _availableModels[modelIndex] = _availableModels[modelIndex].copyWith(
          isDownloading: false,
          downloadProgress: 0.0,
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to download ${model.name}: $error')),
      );
    }
  }

  Future<void> _deleteModel(AIModel model) async {
    try {
      final modelDir = Directory(model.localPath);
      
      if (modelDir.existsSync()) {
        await modelDir.delete(recursive: true);
      }

      setState(() {
        final modelIndex = _availableModels.indexWhere((m) => m.id == model.id);
        _availableModels[modelIndex] = _availableModels[modelIndex].copyWith(
          isDownloaded: false,
          localPath: '',
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${model.name} deleted successfully')),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete ${model.name}: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Models'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView.separated(
        itemCount: _availableModels.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final model = _availableModels[index];
          
          return ListTile(
            title: Text(model.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.description),
                const SizedBox(height: 4),
                Text('Size: ${model.size}'),
                if (model.isDownloading)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: DownloadProgressIndicator(
                      progress: model.downloadProgress,
                    ),
                  ),
              ],
            ),
            isThreeLine: model.isDownloading,
            trailing: model.isDownloaded
              ? IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteModel(model),
                )
              : model.isDownloading
                ? const SizedBox(width: 24)
                : IconButton(
                    icon: const Icon(Icons.download, color: Colors.green),
                    onPressed: () => _downloadModel(model),
                  ),
          );
        },
      ),
    );
  }
}
