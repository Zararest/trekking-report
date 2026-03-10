% tourreport.cls --- класс для отчётов о походах (исправлён)
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tourreport}[2026/03/10 v0.3 Tour report class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax

\LoadClass[12pt,a4paper,oneside]{report}

% ----------------- Базовые пакеты -----------------
\RequirePackage[T2A]{fontenc}    % кодировка шрифтов для кириллицы
\RequirePackage[utf8]{inputenc}
\RequirePackage[russian]{babel}
\RequirePackage{cmap}            % улучшает поиск/копирование в PDF

\RequirePackage{geometry}
\geometry{
  a4paper,
  left=25mm,
  right=20mm,
  top=22mm,
  bottom=25mm
}

% Use TeX Gyre Termes (Times-like) which has good T2A shapes on TeXLive/Overleaf
\RequirePackage{tgtermes}

\RequirePackage{microtype}
\RequirePackage{graphicx}
\RequirePackage{float}
\RequirePackage{caption}
\RequirePackage{booktabs}
\RequirePackage{longtable}
\RequirePackage{array}
\RequirePackage{fancyhdr}
\RequirePackage{hyperref}
\RequirePackage{enumitem}
\RequirePackage{titlesec}
\RequirePackage{ifthen}

% ----------------- Заголовки / отступы -----------------
\titleformat{\chapter}[hang]{\normalfont\LARGE\bfseries}{\thechapter.}{1em}{}
\titleformat{\section}[hang]{\normalfont\Large\bfseries}{\thesection}{0.5em}{}
\titleformat{\subsection}[hang]{\normalfont\large\bfseries}{\thesubsection}{0.5em}{}
\titleformat{\subsubsection}[runin]{\normalfont\normalsize\bfseries}{\thesubsubsection}{0.5em}{}

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
% fix for fancyhdr warning about headheight
\setlength{\headheight}{15pt}

% ----------------- TOC / нумерация глубины -----------------
\setcounter{tocdepth}{3}    % показывать до \subsubsection в содержании
\setcounter{secnumdepth}{3} % нумерация до \subsubsection

% ----------------- Макросы для изображений с защитой -----------------
\newcommand{\protectedincludegraphics}[2][]{%
  \IfFileExists{#2}{%
    \includegraphics[#1]{#2}%
  }{%
    % visible placeholder for missing image
    \fbox{%
      \parbox[b][6cm][c]{0.95\textwidth}{\centering
        \textbf{Placeholder:} \texttt{#2} not found.%
      }%
    }%
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

% ----------------- Hyperref defaults -----------------
\hypersetup{
  pdftitle={},
  pdfauthor={},
  colorlinks=true,
  linkcolor=black,
  citecolor=black,
  urlcolor=black
}

% End of class
\endinput