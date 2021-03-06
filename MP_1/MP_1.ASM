format PE console
include 'win32a.inc'
entry start

section 'data' data readable writeable

        strEnterA db 'Enter A',10,0    ;������ ��� ������
        strEnterB db 'Enter B',10,0
        strAless db 'A < B',10,0
        strAnotless db 'A > B',10,0
        strAequal db 'A = B',10,0
        strScanString  db '%s', 0         ;��� ����� �����
        A db 256 dup(?)    ;������� ��� �����
        B db 256 dup(?)
        result_string dd strAnotless    ;���������� ��� ������

section 'text' code executable readable
start:
        ;����� ��������� �����
        push strEnterA
        call [printf]
        ;���� ������ �
        push A
        push strScanString
        call [scanf]

        push strEnterB
        call [printf]
        ;���� ������ �
        push B
        push strScanString
        call [scanf]

        mov esi,A   ;source = A
        mov edi,B   ;designation = B
        mov ecx,256   ;max string size
        .loop: ;������ �����
        repz cmpsb      ;���������� ��������� source � designation ���� A[n]=B[n] ��� ecx!=0
        test ecx,ecx     ;E��� ecx = 0 �� ������ �����
        jz .equal  ;����� ��������� ��� A = B
        dec esi
        dec edi
        cmpsb       ;��������� ��������� ��������� ���� ����
        ja .show_result    ;���� �� ������ �� � > B
        ;����� ���� A[n]<B[n] �� ������� ��� A < B
        .less:
        mov [result_string],strAless
        ;����� ������
        jmp .show_result
        .equal:
        mov [result_string],strAequal
        .show_result:
        push [result_string]
        call [printf]
        ;��������
        call [getch]
        ;���������� ���������
        push 0
        call [ExitProcess]

section '.idata' import data readable
    library kernel, 'kernel32.dll',\
            msvcrt, 'msvcrt.dll',\
            user32,'USER32.DLL'

include 'api\user32.inc'
include 'api\kernel32.inc'
    import kernel,\
           ExitProcess, 'ExitProcess',\
           HeapCreate,'HeapCreate',\
           HeapAlloc,'HeapAlloc'
  include 'api\kernel32.inc'
    import msvcrt,\
           printf, 'printf',\
           scanf, 'scanf',\
           getch, '_getch'

