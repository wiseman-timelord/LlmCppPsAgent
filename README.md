# LlmCppPsBot
### STATUS: Upload soon...
* Hopefully finish basic version today, its all, figured out and mostly there. 
* Work remaining...
1) Fix small bits of model interaction code. Had to re-create barebones test script, as main program was built on original test script, was good, learned better method of doing the syntax.
2) Create standalone helper script, to detect or otherwise specify, then, download and install, the correct cpp binaries for the processor/graphics being used in the system, instead of it just being as current clblas/avx2.
3) check for .ENV, and if not replicate default from data, from run batch, that is already present in "Llama2Robot-GGUF", and I now realise creates linux incompatibility in  "Llama2Robot-GGUF".

### INTERFACE
* Window_1
```
========================================================================================
                         Chatting with CubeX3900 in the bedroom
========================================================================================
 Mastar's Input
----------------------------------------------------------------------------------------
Hello Computer, are your prompts working now?
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 CubeX3900's Output
----------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Waiting for response...
```

### DESCRIPTION:
The program "LlmCppPsRobot" is a PowerShell-based application designed to serve as a, multi-window & pipelines, based interface for GGUF based models on modern versions of Windows. And by the way, currently there is correct detection of free VRAM, that then compares size of model, and if it is smaller than the free ram, then it will load on gpu, otherwise CPU. Additionally the scripts will be using 85% of the threads available on each, but how many cpu threads/gpu shaders must be, known by the user and set in the ENV.
