# LlmCppPsBot

### STATUS: (Upload in 1-2 days)
* Due to unforseen issues, was not able to release on 19th Sept, but otherwise, the scripts are mostly figured out and implemented. Upload will happen upon completion of basic working version, thinking out further and improving other aspects, while working on main issues. Work remaining for v1.00 is currently...
1) Interaction code. Had to re-create core model interaction test script, as main program was built on original test script, I now can check the scripts with, this and the fully written out prompt logic. In process of having created 2nd model interaction test script, there as bonus learned better method of doing the prompt syntax.
2) New standalone batch "Hw_Setup.bat", that produces a menu, what allows the user to, download and install and configure, the correct "Llama.Cpp" binaries for their own processor/graphics, batch is complete, however, main scripts now need updating.
* Planned updates for >v1.00
1) selection of, primary or secondary, graphics card, I have a 2GB Graphics card somewhere also, so can, test and implement, this, and need, find & download, a 1-2GB languge model first, then there is the factor of the possibility of breaking hardware, for something I am not going to be using currently and that I can't afford to replace (though i do have a crowdfund on my profile).

### DESCRIPTION:
The program "LlmCppPsRobot" is a PowerShell-based application designed to serve as a, multi-window & pipelines, based interface for GGUF based models on modern versions of Windows.

### INTERFACE:
* Window_1, note llm is smaller than free VRam, so it choses GPU...
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
* Window_2, note pipeline signaling saves re-checking key content...
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
* Configure choices of "pre-compiled Llama.Cpp" in "Hw_Setup.bat"...
```
=======================================================
                  HW INSTALL & SETUP 
=======================================================
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  CPU Selection Menu
-------------------------------------------------------
                  1) AMD   (Avx 1)
                  2) AMD   (Avx 2)
                  3) AMD   (Avx 512)
                  4) Other (Non-Avx)
Select a CPU type: 2
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
                  GPU Selection Menu
-------------------------------------------------------
                 1) AMD    (ClBlast)
                 2) nVidia (CuBlas 11)
                 3) nVidia (CuBlas 12)
                 4) Other  (OpenBlas)
Select a GPU type: 1
+++++++++++++++++++++++++++++++++++++++++++++++++++++++
```


### Usage:
The scripts will be using 85% of the threads available, where how many, "cpu threads" and "gpu shaders", must be, known by the user and set in the ENV.

NOTICES:
Credit to "ggerganov" for his work on "Llama.Cpp", this program would not run without the pre-compiled "main.exe" files he/his team has kindly compiled for all the flavors of hardware one would typically require. Find out more about Llama-Cpp [here(github.com/ggerganov)].
