% tourreport.cls --- класс для отчётов о походах (v0.4)
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tourreport}[2026/03/10 v0.4 Tour report class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax

\LoadClass[12pt,a4paper,oneside]{report}

% ----------------- Базовые пакеты -----------------
\RequirePackage[T2A]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[russian]{babel}
\RequirePackage{cmap}

\RequirePackage{geometry}
\geometry{
  a4paper,
  left=25mm,
  right=20mm,
  top=22mm,
  bottom=25mm
}

\RequirePackage{tgtermes}  % Times-like with good T2A
\RequirePackage{microtype}
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{caption}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{array}
\RequirePackage{tabularx}
\RequirePackage{fancyhdr}
\RequirePackage{hyperref}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{xparse}
\RequirePackage{ifthen}

% ----------------- Заголовки / отступы -----------------
\titleformat{\chapter}[hang]{\normalfont\LARGE\bfseries}{\thechapter.}{1em}{}
\titleformat{\section}[hang]{\normalfont\Large\bfseries}{\thesection}{0.5em}{}
\titleformat{\subsection}[hang]{\normalfont\large\bfseries}{\thesubsection}{0.5em}{}

\titlespacing*{\chapter}{0pt}{-10pt}{12pt}
\titlespacing*{\section}{0pt}{10pt}{6pt}
\titlespacing*{\subsection}{0pt}{8pt}{4pt}

% ----------------- Абзацы -----------------
\setlength{\parindent}{1.25cm}
\setlength{\parskip}{0pt}

% ----------------- Колонтитулы -----------------
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\footnotesize\itshape \leftmark}
\fancyhead[R]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\setlength{\headheight}{15pt} % безопасная высота для fancyhdr

% ----------------- TOC / нумерация глубины -----------------
\setcounter{tocdepth}{3}
\setcounter{secnumdepth}{3}

% ----------------- Защищённый includegraphics -----------------
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
% Section 1 helpers (tour info, route, obstacles)
% =================================================

% --- 1.1: tour info two-column table ---
\newenvironment{tourinfotable}{%
  \begin{table}[H]\centering\small
  \begin{tabularx}{\textwidth}{>{\raggedright\arraybackslash}p{6.5cm} X}
  \toprule
}{%
  \bottomrule
  \end{tabularx}
  \end{table}
}
\newcommand{\tourinfo}[2]{#1 & #2 \\}

% --- 1.2/1.3: route macro ---
% \route{<label>}{<sequence text>}
% label optional: if empty, pass {}.
\NewDocumentCommand{\route}{O{} m}{%
  \par\medskip
  \noindent\textbf{#2}\par\smallskip
  \noindent\begin{tabularx}{\textwidth}{X}
    #1
  \end{tabularx}
  \par\medskip
}

% Alternative simpler interface: \routeseq{<sequence text>} which prints with label "Нитка маршрута:"
\NewDocumentCommand{\routeseq}{m}{\route[#1]{Нитка маршрута:}}

% --- 1.4: obstacles table (4 columns) ---
\newenvironment{obstacletable}{%
  \begin{table}[H]\centering\small
  \begin{tabularx}{\textwidth}{>{\raggedright\arraybackslash}p{3.8cm} >{\centering\arraybackslash}p{1.6cm} >{\raggedright\arraybackslash}p{4.7cm} X}
  \toprule
  \textbf{Препятствие} & \textbf{К.т.} & \textbf{Время прохождения, перепад высот} & \textbf{Характер склонов} \\
  \midrule
}{%
  \bottomrule
  \end{tabularx}
  \end{table}
}
\newcommand{\obstaclerow}[4]{#1 & #2 & #3 & #4 \\}

% --- 1.5: participants accumulator (add/print) ---
\newcommand{\@participantslist}{}%
\newcommand{\addparticipant}[4]{%
  \g@addto@macro\@participantslist{#1 & #2 & #3 & #4 \\ \midrule }
}
\newcommand{\printparticipants}{%
  \begin{table}[H]\centering\small
  \begin{tabular}{p{0.7cm} p{5.5cm} p{3.5cm} p{4cm}}
  \toprule
  \textbf{№} & \textbf{ФИО} & \textbf{Город} & \textbf{Роль / примечание} \\
  \midrule
  \@participantslist
  \bottomrule
  \end{tabular}
  \caption{Состав группы}
  \end{table}
}

% --- day entry helper (удобный синтаксис для дневниковых строк) ---
\newcommand{\dayentry}[2][]{%
  \subsection*{#2}%
  \phantomsection
  \addcontentsline{toc}{subsection}{#2}%
  \ifthenelse{\equal{#1}{}}{}{\label{#1}}%
}

% =================================================
% Hyperref defaults (пустые по умолчанию; main.tex может задать)
% =================================================
\hypersetup{
  pdftitle={},
  pdfauthor={},
  colorlinks=true,
  linkcolor=black,
  citecolor=black,
  urlcolor=black
}

\endinput