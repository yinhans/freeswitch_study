🎉 服务器环境
os：ubuntu20.4 x86 64位芯片
## 模型下载位置
无论是使用命令行还是ModelScope SDK，默认模型会下载到~/.cache/modelscope/hub目录下。如果需要修改cache目录，可以手动指定环境变量：MODELSCOPE_CACHE，指定后，模型将下载到该环境变量指定的目录中。

### 使用命令行工具下载模型
```bash
modelscope download --help

    usage: modelscope <command> [<args>] download [-h] --model MODEL [--revision REVISION] [--cache_dir CACHE_DIR] [--local_dir LOCAL_DIR] [--include [INCLUDE ...]] [--exclude [EXCLUDE ...]] [files ...]
    
    positional arguments:
      files                 Specify relative path to the repository file(s) to download.(e.g 'tokenizer.json', 'onnx/decoder_model.onnx').
    
    options:
      -h, --help            show this help message and exit
      --model MODEL         The model id to be downloaded.
      --revision REVISION   Revision of the model.
      --cache_dir CACHE_DIR
                            Cache directory to save model.
      --local_dir LOCAL_DIR
                            File will be downloaded to local location specified bylocal_dir, in this case, cache_dir parameter will be ignored.
      --include [INCLUDE ...]
                            Glob patterns to match files to download.Ignored if file is specified
      --exclude [EXCLUDE ...]
                            Glob patterns to exclude from files to download.Ignored if file is specified
```
### 使用示例
比如本次语音识别示例使用的是Paraformer语音识别-中文-通用-16k-离线-large-长音频版<br/>
使用下面的命令进行安装
```bash
modelscope download --model 'iic/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-pytorch'
```
也可以将整个模型repo下载到指定目录
```bash
modelscope download --model 'iic/speech_paraformer-large-vad-punc_asr_nat-zh-cn-16k-common-vocab8404-pytorch' --local_dir 'path/to/dir'
```