% tourreport.cls --- класс для отчётов о походах (v0.7, route fixed)
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tourreport}[2026/03/10 v0.7 Tour report class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax

\LoadClass[12pt,a4paper,oneside]{report}

% ----------------- Пакеты -----------------
\RequirePackage[T2A]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[russian]{babel}
\RequirePackage{cmap}

\RequirePackage{geometry}
\geometry{a4paper,left=25mm,right=20mm,top=22mm,bottom=25mm}

\RequirePackage{tgtermes}
\RequirePackage{microtype}
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{caption}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{array}
\RequirePackage{tabularx} % используется в obstacles
\RequirePackage{makecell}
\RequirePackage{fancyhdr}
\RequirePackage{hyperref}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{xparse}
\RequirePackage{ifthen}
\RequirePackage{calc}

% ----------------- Оформление -----------------
\titleformat{\chapter}[hang]{\normalfont\LARGE\bfseries}{\thechapter.}{1em}{}
\titleformat{\section}[hang]{\normalfont\Large\bfseries}{\thesection}{0.5em}{}
\titleformat{\subsection}[hang]{\normalfont\large\bfseries}{\thesubsection}{0.5em}{}

\titlespacing*{\chapter}{0pt}{-10pt}{12pt}
\titlespacing*{\section}{0pt}{10pt}{6pt}
\titlespacing*{\subsection}{0pt}{8pt}{4pt}

\setlength{\parindent}{1.25cm}
\setlength{\parskip}{0pt}

\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\footnotesize\itshape \leftmark}
\fancyhead[R]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\setlength{\headheight}{15pt}

\setcounter{tocdepth}{3}
\setcounter{secnumdepth}{3}

% ------------- защищённый includegraphics -------------
\newcommand{\protectedincludegraphics}[2][]{%
  \IfFileExists{#2}{\includegraphics[#1]{#2}}{%
    \fbox{\parbox[b][6cm][c]{0.95\textwidth}{\centering\textbf{Placeholder:} \texttt{#2} not found.}}%
  }%
}

\newcommand{\insertmap}[2][]{%
  \begin{figure}[H]\centering
    \protectedincludegraphics[width=0.95\textwidth]{#2}
    \caption{#1}
  \end{figure}
}

\newcommand{\inserthighplot}[2][]{%
  \begin{figure}[H]\centering
    \protectedincludegraphics[width=0.95\textwidth]{#2}
    \caption{#1}
  \end{figure}
}

% =================================================
% Section 1 helpers (stable)
% =================================================
\makeatletter

% tourinfotable (stable, uses parbox for second column)
\newlength{\tourinfoFirstWidth}
\setlength{\tourinfoFirstWidth}{6.5cm}
\newlength{\tourinfoSecondWidth}
\setlength{\tourinfoSecondWidth}{\dimexpr\textwidth-\tourinfoFirstWidth-2\tabcolsep\relax}

\newenvironment{tourinfotable}{%
  \begin{table}[H]\centering\small
  \begin{tabular}{@{} p{\tourinfoFirstWidth} p{\tourinfoSecondWidth} @{}}
  \toprule
}{%
  \bottomrule
  \end{tabular}
  \end{table}
}
\newcommand{\tourinfo}[2]{#1 & \parbox[t]{\tourinfoSecondWidth}{\raggedright #2} \\}

% ---------------- Маршрут ----------------

\newenvironment{routeblock}
{
\begin{quote}
\itshape
}
{
\end{quote}
}

% obstacles table (tabularx — контролируем содержимое)
% ---------------- Таблица препятствий ----------------

\newenvironment{obstacletable}
{
\begin{table}[H]
\centering
\small
\begin{tabular}{
p{3.2cm}
p{1.2cm}
p{5.2cm}
p{5.2cm}
}
\toprule
\textbf{Препятствие} &
\textbf{К.т.} &
\textbf{Время прохождения, перепад высот} &
\textbf{Характер склонов} \\
\midrule
}
{
\bottomrule
\end{tabular}
\end{table}
}

\newcommand{\obstaclerow}[4]{
#1 & #2 & #3 & #4 \\
}

% ---------------- Состав группы ----------------

\makeatletter

\newcommand{\@participantslist}{}

\newcommand{\addparticipant}[4]{%
\g@addto@macro\@participantslist{#1 & #2 & #3 & #4 \\}
}

\newenvironment{participantstable}
{
\begin{table}[H]
\centering
\small
\begin{tabular}{
p{1cm}
p{6cm}
p{3.5cm}
p{4.5cm}
}
\toprule
\textbf{№} &
\textbf{ФИО} &
\textbf{Город} &
\textbf{Роль} \\
\midrule
}
{
\bottomrule
\end{tabular}
\end{table}
}

\newcommand{\printparticipants}{
\begin{participantstable}
\@participantslist
\end{participantstable}
}

\makeatother

% day entry helper
\newcommand{\dayentry}[2][]{%
  \subsection*{#2}%
  \phantomsection
  \addcontentsline{toc}{subsection}{#2}%
  \ifthenelse{\equal{#1}{}}{}{\label{#1}}%
}

\makeatother

% hyperref defaults
\hypersetup{pdftitle={},pdfauthor={},colorlinks=true,linkcolor=black,citecolor=black,urlcolor=black}

\endinput