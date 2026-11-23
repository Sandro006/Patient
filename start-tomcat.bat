@echo off
REM =====================================================
REM Demarrage de Tomcat 10.1 pour le projet FrontController
REM -----------------------------------------------------
REM Tomcat 10.1 exige Java 11+. Le JAVA_HOME global de
REM cette machine pointe vers JDK 8, donc on force
REM JDK 21 uniquement pour cette session.
REM =====================================================

setlocal
set "CATALINA_HOME=C:\Program Files\Apache Software Foundation\Tomcat 10.1"
set "CATALINA_BASE=%CATALINA_HOME%"
set "JAVA_HOME=C:\Program Files\Java\jdk-21"
set "JRE_HOME="
cd /d "%CATALINA_HOME%\bin"
call startup.bat
echo.
echo Tomcat demarre : http://localhost:8080/MonFramework/
echo Pour l'arreter : shutdown.bat (meme dossier bin)
echo.
