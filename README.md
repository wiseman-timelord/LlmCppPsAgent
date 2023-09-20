# LlmCppPsBot

### STATUS: (Upload in 1-2 days)
* Due to unforseen issues, was not able to release on 19th Sept, but otherwise, the scripts are mostly figured out and implemented. Upload will happen upon completion of basic working version.
* Work remaining for v1.00 is currently...
1) Interaction code. Had to re-create core model interaction test script, as main program was built on original test script, I now can check the scripts with, this and the fully written out prompt logic. In process of having created 2nd model interaction test script, there as bonus learned better method of doing the prompt syntax.
* Planned updates for >v1.00
1) standalone script, to detect hardware, then, download and install, the correct cpp binaries for the processor/graphics being used in the system, instead of it just being clblas/avx2 only.
2) selection of which graphics card to use, I have a 2GB Graphics card somewhere also, so can test and implement this, if I can find a small model.

### DESCRIPTION:
The program "LlmCppPsRobot" is a PowerShell-based application designed to serve as a, multi-window & pipelines, based interface for GGUF based models on modern versions of Windows.

### INTERFACE:
* Window_1, note llm is smaller than free VRam, so it choses GPU.
```
========================================================================================
                            Engine started - 2023/09/20 19:46                           
========================================================================================
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Engine Output
----------------------------------------------------------------------------------------
Clearing input/output keys for config_1...
Waiting for GPU stats...
GPU: Radeon (TM) RX 470 Graphics - 6464MB.
Inspecting the models...
Model: llama-2-7b-chat.Q2_K.gguf - 2695 MB
Using safe number of 1740 threads.
Main used: .\llama\clblas\main.exe.
Listening for pipeline notifications...


```
* Window_2, note pipeline signaling saves re-checking key content.
```
========================================================================================
                      Chatting with Desktop_PC in the Users_Home
========================================================================================
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 PC_User's Input
----------------------------------------------------------------------------------------
Hello Computer, are your prompts working now?
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Desktop_PC's Output
----------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Waiting for response...



```

### Usage:
The scripts will be using 85% of the threads available, where how many, "cpu threads" and "gpu shaders", must be, known by the user and set in the ENV.

