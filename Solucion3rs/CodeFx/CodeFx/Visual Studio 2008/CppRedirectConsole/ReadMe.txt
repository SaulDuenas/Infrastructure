========================================================================
    WINDOWS APPLICATION : CppRedirectConsole Project Overview
========================================================================

/////////////////////////////////////////////////////////////////////////////
Use:

CppRedirectConsole demostrates redirecting stdin and stdout put from a 
console application to a windows form application. The sample uses 
named pipes to communicate between different processes.

1. StdIn Pipe

Console Process (Read) <-- (Write) Windows Form Process

2. StdOut Pipe

Console Process (Write) --> (Read) Windows Form Process

CppRedirectConsole class has following members:

Properties:
// The handle of sub process
HANDLE ChildProcess

Methods:
// Start specified sub process
void StartSubProcess(char* szProcessText);
// Write charectors to stdin pipe
void WriteStdIn(char* szInput);
// Read charecors to stdout pipe
BOOL ReadStdOut(char* szOutput);


/////////////////////////////////////////////////////////////////////////////
Manual:

Step1: Build and and start the project

Step2: In the top input box, type the process path.
For example: cmd.exe

Step3: Click "Start" to start the sub processes
The console process is hidden. The initial output will be redirect to
windows form.

Step4: Type command in the bottom input box
For example: dir

Step5: Click Input button to send input to console process
The output will also be redirected to windows form


/////////////////////////////////////////////////////////////////////////////
Code Logic:

1. Windows form process initializes and shows a windows dialog

When Start button is clicked:

2. Windows form process creates all the named pipes with 
inheritance flag enabled.

3. It also create sub process and passing named pipes to it.

4. Windows form process creates a thread to monitoring the sub process

5. In the monitor process, it redirects initial output to windows form

When Input button is clicked:

6. Windows form process writes input to stdin pipe

7. Console process reads stdin pipe and write its response to stdout

8. In the monitor process, it reads output from stdout pipe and write it
to the windows form control.


/////////////////////////////////////////////////////////////////////////////
References:

Creating a Child Process with Redirected Input and Output
http://msdn.microsoft.com/en-us/library/ms682499(VS.85).aspx

Redirecting an arbitrary Console's Input/Output
http://www.codeproject.com/KB/threads/redir.aspx


/////////////////////////////////////////////////////////////////////////////
