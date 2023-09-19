# LlmCppPsBot
### STATUS: Upload soon...
* Hopefully finish basic version today, its all, figured out and mostly there. 
* Work remaining...
1) Fix small bits of model interaction code.
2) Create standalone helper script, to detect, then, download and install, the correct cpp binaries for the processor/graphics being used in the system, instead of it just being as current clblas/avx2.

### DESCRIPTION:
The program "LlmCppPsRobot" is a PowerShell-based application designed to serve as a, multi-window & pipelines, based interface for GGUF based models on modern versions of Windows. And by the way, currently there is correct detection of free VRAM, that then compares size of model, and if it is smaller than the free ram, then it will load on gpu, otherwise CPU. Additionally the scripts will be using 85% of the threads available on each, but how many cpu threads/gpu shaders must be, known by the user and set in the ENV.
