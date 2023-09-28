# LlmCppPsBot

### STATUS: 
* Alpha - Working on solid release.
<br>The scripts are mostly figured out, improving various aspects, finding and testing, libraries, logic of core functions, in place and being reworked.
1) Model Interaction - Expanded to 3 config files for keys
2) upgraded interface - now with, mapped and color, content.

### OUTSTANDING:
1) Syntax Menu - select syntax format from some shortlist of popular formats, this then set to settings file for next run. formats such as, "### Instruction" (used by Daydreamer v3) or "[INST] <<SYS>>" (used by Llama2) or "{system_message} User:" (used by Falcon), will review this later. 
2) Already has temp implemented in title of engine, when interaction done, must try and re-integrate so people can see updated information about temps, as I feel this is important, additionally would ideally involve freezing of areas of text on the display. Researching into shell enhancements.

### DESCRIPTION:
The "LlmCppPsBot" is a sophisticated PowerShell application that integrates GGUF-based models into a dual-window interface on contemporary Windows platforms. Specifically, the, "window_1" and "window_2", scripts are launched independently via batch, with "window_1" dedicated to the engine's operations and "window_2" offering a seamless chat interface. The program leverages ".ENV" file for environment configurations, ensuring adaptability and ease of setup. Additionally, a standalone batch "configuration" is incorporated, streamlining the process of hardware configuration and facilitating the download of essential libraries. This design ensures a robust and user-friendly experience for those interacting with the GGUF models.

### INTERFACE:
* Window_1, note llm is smaller than free VRam, so it choses GPU...
```
========================================================================================
                 CPU 43c, GPU 50c - Engine Online - 2023/09/21, 21:39
========================================================================================
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Engine Output:
----------------------------------------------------------------------------------------
Clearing input/output keys for config_1...
Waiting for GPU stats...
GPU: Radeon (TM) RX 470 Graphics - 6464MB.
Inspecting the models...
Model: llama-2-7b-chat.Q2_K.gguf - 2695 MB
Using safe number of 1740 threads.
Main used: .\llama\gpu\main.exe.
Listening for pipeline notifications...







```
* Window_2, note pipeline signaling saves re-checking key content...
```
========================================================================================
                      Chatting with Desktop_PC in the Users_Home
========================================================================================
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 PC_User's Last Input:
----------------------------------------------------------------------------------------
Hello Computer, are your prompts working now?
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Desktop_PC's Last Output:
----------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 Your Current Input:
----------------------------------------------------------------------------------------

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Waiting for response...



```

### USAGE:
1) Run "Configuration.bat", ensure you know your hardware specs, and then choose your binaries accordingly, the batch will take care of the rest (providing you dont have abnormal system settings).   
2) Ensure you have inserted a GGUF format of model into the ".\models" folder, [this one](https://huggingface.co/TheBloke/Llama-2-7b-Chat-GGUF/blob/main/llama-2-7b-chat.Q4_0.gguf) will do, just the "example_llm_name.gguf" file itself, thats 1 file, don't confuse it with 2+.
3) Run "LlmCppPsBot.bat", the program is then running, however, if there is no ".\.ENV" (first run), then it will generate one, and you should make a quick edit upon it, and then run "LlmCppPsBot.bat" again.

### COMPATIBILITY:
* Hardware Support - Avx1, Avx2, Avx 512, Non-Avx, ClBlast, CuBlase 11, CuBlas 12, OpenBlas. Use, [HWinfo](https://www.guru3d.com/download/hwinfo64-download) and [GPUz](https://www.guru3d.com/download/gpu-z-2-1/), to figure out your tech.
* Model Support - Currently being developed for "[INST] <<SYS>>" syntax, such as Llama-2 models: [Llama-2-7b-Chat-GGUF](https://huggingface.co/TheBloke/Llama-2-7b-Chat-GGUF), [Llama-2-13B-chat-GGUF](https://huggingface.co/TheBloke/Llama-2-13B-chat-GGUF), [Llama-2-70B-chat-GGUF](https://huggingface.co/TheBloke/Llama-2-70B-chat-GGUF), though later this will be expanded through syntax selection menu.

### BACKBURNER:
<br>Features I requires [funding](https://crowdfunder.co.uk/p/wiseman-timelord) for...  
* To add Selection of, primary or secondary, graphics cards - Require new ATX AM4 based motherboard so as to have spaced out PCIE x16 slots, currently this will take me a while to aquire.

### NOTICES:
* Credit to "ggerganov" for his work on [Llama.Cpp](https://github.com/ggerganov), this program would not run without the pre-compiled "main.exe" files he/his team has kindly compiled for most themes of hardware.
* Library [LibreOpenHardwareMonitor](https://github.com/LibreHardwareMonitor/LibreHardwareMonitor) is used to gain CPU/GPU temps, this is a variation of [Open Hardware Monitor](https://openhardwaremonitor.org/), a great app for, cpu, gpu, ram, monitoring on system tray.
