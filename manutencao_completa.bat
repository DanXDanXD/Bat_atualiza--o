@echo off
:: Solicita permissão de administrador
NET FILE 1>NUL 2>NUL || (powershell start-process "%0" -verb runas & exit)

echo ======================================
echo INICIANDO MANUTENÇÃO DO SISTEMA
echo ======================================
echo.

:: Lista todas as unidades usando PowerShell
for /f %%D in ('powershell -Command "Get-PSDrive | Where-Object { $_.Provider.Name -eq 'FileSystem' } | Select-Object -ExpandProperty Name"') do (
    echo --------------------------------
    echo Processando disco: %%D
    echo --------------------------------

    :: Limpeza de disco apenas no C:
    if "%%D:"=="C:" (
        echo Limpando arquivos desnecessários...
        cleanmgr /sagerun:1
        echo LIMPEZA FINALIZADA!
    )

    echo.
    pause

    :: Verificação de erros no disco
    echo Verificando erros no disco %%D...
    chkdsk %%D: /F /R /X
    echo VERIFICAÇÃO FINALIZADA!

    echo.
    pause

    :: Desfragmentação do disco
    echo Desfragmentando o disco %%D...
    defrag %%D: /O
    echo DESFRAGMENTAÇÃO FINALIZADA!

    echo.
    pause
)

:: Atualização dos drivers
echo ======================================
echo ATUALIZANDO DRIVERS DO SISTEMA...
echo ======================================
pnputil /scan-devices
pnputil /update-drivers /subdirs /reboot
echo DRIVERS ATUALIZADOS!

echo.
pause

:: Atualização dos programas com Winget
echo ======================================
echo ATUALIZANDO PROGRAMAS INSTALADOS...
echo ======================================
winget upgrade --all --silent
echo PROGRAMAS ATUALIZADOS!

echo.
pause

echo ======================================
echo TODAS AS TAREFAS FORAM CONCLUÍDAS!
echo ======================================
pause
