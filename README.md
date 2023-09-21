# LlmCppPsBot

### STATUS: Alpha (Working in next few days, got distracted by what I planned to be updates, but, in turn with these parts done, its easier to focus).
* The scripts are mostly figured out and implemented. Upload will happen upon completion of basic working version, thinking out further and improving other aspects, while working on main scripts. Work remaining for v1.00 is currently...
1) Interaction code. Had to re-create core model interaction test script, as main program was built on original test script, I now can check the scripts with, this and the fully written out prompt logic. In process of having created 2nd model interaction test script, there as bonus learned better method of doing the prompt syntax.
2) New standalone batch "Configuration.bat", that produces a menu, what allows the user to, download and install and configure, the correct "Llama.Cpp" binaries for their own processor/graphics, batch is complete, however, main scripts now need updating.
3) Menu to select prompt format, dunno, maybe compare model name to shortlist, to see if previously set, and if not, then ask user to select from options, "### Instruction" (used by Daydreamer v3) or "[INST] <<SYS>>" (used by Llama2) or "{system_message} User:" (used by Falcon), syntax formats, will review this later.
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
* Configuration, choice and download, of "Llama.Cpp" combination...
```
=======================================================
                Hardware Configuration
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
1) Run "Configuration.bat", ensure you know your hardware specs (HWinfo and GPUz, are good for this, or look up online), and then choose your binaries accordingly, the batch will take care of the rest (providing you dont have abnormal system settings).   
2) Ensure you have inserted a GGUF format of model into the ".\models" folder, ([this one](https://huggingface.co/TheBloke/Llama-2-7b-Chat-GGUF/blob/main/llama-2-7b-chat.Q4_0.gguf)) will do, just the "example_llm_name.gguf" file itself, thats 1 file, don't confuse it with 2+.
3) Run "LlmCppPsBot.bat", the program is then running, however, if there is no ".\.ENV" (first run), then it will generate one, and you should make a quick edit upon it, and then run "LlmCppPsBot.bat" again.

### COMPATIBILITY:
* Currently being developed for "[INST] <<SYS>>" syntax, this includes official Llama-2 models, such as: ([Llama-2-7b-Chat-GGUF](https://huggingface.co/TheBloke/Llama-2-7b-Chat-GGUF)), ([Llama-2-13B-chat-GGUF](https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF)), ([Llama-2-70B-chat-GGUF](https://huggingface.co/TheBloke/Llama-2-70B-chat-GGUF)), though later this will be expanded through syntax selection menu.

NOTICES:
* Credit to "ggerganov" for his work on "Llama.Cpp", this program would not run without the pre-compiled "main.exe" files he/his team has kindly compiled for most themes of hardware. Find out more about Llama-Cpp [here](https://github.com/ggerganov).
* Interacting with language models requires your CPU/GPU to run at, in this case 85%, for prolongued periods of time on top of whatever else you have going on, so keep an eye on the temps, because most games are no stress test for decent modern hardware.
