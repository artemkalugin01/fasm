format PE console
include 'win32a.inc'
entry start

section 'data' data readable writeable

        strEnterA db 'Enter A',10,0    ;Строки для вывода
        strEnterB db 'Enter B',10,0
        strAless db 'A < B',10,0
        strAnotless db 'A > B',10,0
        strAequal db 'A = B',10,0
        strScanString  db '%s', 0         ;Для ввода строк
        A db 256 dup(?)    ;Массивы для строк
        B db 256 dup(?)
        result_string dd strAnotless    ;Переменная для ответа

section 'text' code executable readable
start:
        ;Вывод начальных строк
        push strEnterA
        call [printf]
        ;Ввод строки А
        push A
        push strScanString
        call [scanf]

        push strEnterB
        call [printf]
        ;Ввод строки Б
        push B
        push strScanString
        call [scanf]

        mov esi,A   ;source = A
        mov edi,B   ;designation = B
        mov ecx,256   ;max string size
        .loop: ;Начало цикла
        repz cmpsb      ;Побайтовое сравнение source и designation пока A[n]=B[n] или ecx!=0
        test ecx,ecx     ;Eсли ecx = 0 то строки равны
        jz .equal  ;Вывод сообщения что A = B
        dec esi
        dec edi
        cmpsb       ;Повторное сравнение последних двух байт
        ja .show_result    ;Если он больше то А > B
        ;Иначе если A[n]<B[n] то вывесли что A < B
        .less:
        mov [result_string],strAless
        ;Вывод ответа
        jmp .show_result
        .equal:
        mov [result_string],strAequal
        .show_result:
        push [result_string]
        call [printf]
        ;Ожидание
        call [getch]
        ;Завершение программы
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

