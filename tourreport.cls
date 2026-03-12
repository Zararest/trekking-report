% tourreport.cls --- класс для отчётов о горных походах
% Версия: 1.0 (адаптировано под требования секции)
% Основан на стандартном классе report.
% Предоставляет удобные окружения и команды для оформления
% справочных сведений, таблиц препятствий, состава группы,
% графика движения и технического описания.

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tourreport}[2026/03/10 v1.0 Tour report class]

% Передача необработанных опций классу report
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions\relax

% Загружаем базовый класс с настройками
\LoadClass[12pt,a4paper,oneside]{report}

% --------------------------
% БЛОК ПОДКЛЮЧЕНИЯ ПАКЕТОВ
% --------------------------
\RequirePackage[T2A]{fontenc}        % кодировка шрифтов для кириллицы
\RequirePackage[utf8]{inputenc}      % кодировка исходного текста
\RequirePackage[russian]{babel}      % русский язык
\RequirePackage{cmap}                 % поиск и копирование кириллицы в PDF

\RequirePackage{geometry}             % поля страницы
\geometry{a4paper,left=25mm,right=20mm,top=22mm,bottom=25mm}

\RequirePackage{tgtermes}             % шрифт Times (современная альтернатива)
\RequirePackage{microtype}            % микротипографика
\RequirePackage{graphicx}             % вставка изображений
\RequirePackage{float}                 % опция H для размещения рисунков/таблиц
\RequirePackage{caption}               % настройка подписей
\RequirePackage{booktabs}              % красивые линии в таблицах
\RequirePackage{longtable}              % таблицы на несколько страниц
\RequirePackage{makecell}               % перенос строк в ячейках
\RequirePackage{fancyhdr}               % колонтитулы
\RequirePackage{hyperref}               % гиперссылки
\RequirePackage{enumitem}                % настройка списков
\RequirePackage{titlesec}                % оформление заголовков
\RequirePackage{xparse}                   % расширенное определение команд
\RequirePackage{ifthen}                   % условные операторы
\RequirePackage{calc}                      % арифметика длин
\RequirePackage{array}                     % дополнительные типы колонок
\RequirePackage{underscore}                % разрешает символ _ вне математики

% --------------------------
% НАСТРОЙКИ ОФОРМЛЕНИЯ
% --------------------------
% Заголовки глав, разделов, подразделов
\titleformat{\chapter}[hang]{\normalfont\LARGE\bfseries}{\thechapter.}{1em}{}
\titleformat{\section}[hang]{\normalfont\Large\bfseries}{\thesection}{0.5em}{}
\titleformat{\subsection}[hang]{\normalfont\large\bfseries}{\thesubsection}{0.5em}{}

% Отступы вокруг заголовков
\titlespacing*{\chapter}{0pt}{-10pt}{12pt}
\titlespacing*{\section}{0pt}{10pt}{6pt}
\titlespacing*{\subsection}{0pt}{8pt}{4pt}

% Абзацный отступ и интервал
\setlength{\parindent}{1.25cm}
\setlength{\parskip}{0pt}

% Колонтитулы
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{\footnotesize\itshape \leftmark}
\fancyhead[R]{\thepage}
\renewcommand{\headrulewidth}{0.4pt}
\setlength{\headheight}{15pt}

% Глубина оглавления и нумерации
\setcounter{tocdepth}{3}
\setcounter{secnumdepth}{3}

% Настройки таблиц
\renewcommand{\arraystretch}{1.2}    % увеличенный межстрочный интервал
\setlength{\tabcolsep}{6pt}           % отступ от границ ячеек

% --------------------------
% ЗАЩИЩЁННАЯ ВСТАВКА ИЗОБРАЖЕНИЙ
% --------------------------
% Если файл не найден, вместо ошибки выводится рамка с именем файла
\newcommand{\protectedincludegraphics}[2][]{%
  \IfFileExists{#2}{\includegraphics[#1]{#2}}{%
    \fbox{\parbox[b][6cm][c]{0.95\textwidth}{\centering\textbf{Placeholder:} \texttt{#2} not found.}}%
  }%
}

% Вставка карты с подписью (плавающий рисунок)
\newcommand{\insertmap}[2][]{%
  \begin{figure}[H]\centering
    \protectedincludegraphics[width=0.95\textwidth]{#2}
    \caption{#1}
  \end{figure}
}

% Вставка высотного графика (аналогично карте, но можно переопределить отдельно)
\newcommand{\inserthighplot}[2][]{%
  \begin{figure}[H]\centering
    \protectedincludegraphics[width=0.95\textwidth]{#2}
    \caption{#1}
  \end{figure}
}

% --------------------------
% ОКРУЖЕНИЯ И КОМАНДЫ ДЛЯ ГЛАВЫ 1 «СПРАВОЧНЫЕ СВЕДЕНИЯ»
% --------------------------
\makeatletter

% Таблица общих сведений (две колонки: параметр и значение)
\newlength{\tourinfoFirstWidth}
\setlength{\tourinfoFirstWidth}{6.5cm}
\newlength{\tourinfoSecondWidth}
\setlength{\tourinfoSecondWidth}{\dimexpr\textwidth-\tourinfoFirstWidth-2\tabcolsep\relax}

\newenvironment{tourinfotable}
{%
  \begin{table}[H]
  \centering
  \small
  \begin{tabular}{|p{\tourinfoFirstWidth}|p{\tourinfoSecondWidth}|}
  \hline
}{%
  \hline
  \end{tabular}
  \end{table}
}

% Команда для заполнения строки таблицы: первый аргумент — название, второй — значение
\newcommand{\tourinfo}[2]{#1 & #2 \\ \hline}

% Блок для отображения нитки маршрута (курсив, с отступами)
\newenvironment{routeblock}
{%
  \begin{quote}
  \itshape
}{%
  \end{quote}
}

% Таблица определяющих препятствий
\newenvironment{obstacletable}
{%
  \begin{table}[H]
  \centering
  \small
  \begin{tabular}{|p{3.2cm}|p{1.2cm}|p{5.2cm}|p{5.2cm}|}
  \hline
  \textbf{Препятствие} &
  \textbf{К.т.} &
  \textbf{Время прохождения, перепад высот} &
  \textbf{Характер склонов} \\
  \hline
}{%
  \end{tabular}
  \end{table}
}

% Команда для добавления строки в таблицу препятствий
\newcommand{\obstaclerow}[4]{#1 & #2 & #3 & #4 \\ \hline}

% --------------------------
% ТАБЛИЦА СОСТАВА ГРУППЫ
% --------------------------
% Внутренний макрос для накопления записей
\newcommand{\@participantslist}{}

% Добавление участника: 1-фото, 2-ФИО, 3-работа, 4-год рождения,
% 5-походный опыт, 6-должность в походе
\newcommand{\addparticipant}[6]{%
  \g@addto@macro\@participantslist{%
    \includegraphics[width=2.8cm]{#1} &
    #2 &
    #3 &
    #4 &
    #5 &
    #6 \\ \hline
  }%
}

% Окружение для таблицы участников (с отцентрированными ячейками)
\newenvironment{participantstable}
{%
  \begin{table}[H]
  \centering
  \small
  \setlength{\tabcolsep}{4pt}
  \begin{tabular}{
    | >{\centering\arraybackslash}m{3cm}   |   % фото
    | >{\centering\arraybackslash}m{4cm}   |   % ФИО
    | >{\centering\arraybackslash}m{2.5cm} |   % место работы
    | >{\centering\arraybackslash}m{1.2cm} |   % год рождения
    | >{\centering\arraybackslash}m{1.8cm} |   % опыт
    | >{\centering\arraybackslash}m{2.5cm} |   % должность
  }
  \hline
  \textbf{Фотография} &
  \textbf{ФИО} &
  \textbf{Место работы, должность} &
  \textbf{Год рождения} &
  \textbf{Походный опыт} &
  \textbf{Должность в походе} \\
  \hline
}{%
  \end{tabular}
  \end{table}
}

% Вывод накопленного списка участников
\newcommand{\printparticipants}{%
  \begin{participantstable}
    \@participantslist
  \end{participantstable}
}

% --------------------------
% ТАБЛИЦА ГРАФИКА ДВИЖЕНИЯ (ГЛАВА 4)
% --------------------------
% Используется longtable для возможности разрыва между страницами
\newenvironment{schedulestable}[2][]{%
  \begingroup
  \scriptsize                 % мелкий шрифт, чтобы таблица помещалась
  \setlength{\tabcolsep}{4pt}
  \begin{longtable}[c]{
    | >{\centering\arraybackslash}p{1.3cm}
    | >{\centering\arraybackslash}p{0.8cm}
    | p{4.4cm}
    | >{\centering\arraybackslash}p{1.5cm}
    | >{\centering\arraybackslash}p{1.2cm}
    | >{\centering\arraybackslash}p{1.3cm}
    | p{3.0cm}
    | p{2.0cm}
  |}
  \caption{#2}%               подпись таблицы
  \if\relax\detokenize{#1}\relax\else\label{#1}\fi\\  % метка, если задана
  \hline
  \makecell{Даты} & \makecell{Дни\\пути} & \makecell{Участки\\маршрута} & \makecell{Протя-\\жённость,\\км*} & \makecell{ЧХВ} & \makecell{Перепад\\высот, м} & \makecell{Определяющие\\препятствия} & \makecell{Погода} \\
  \hline
  \endfirsthead
  \hline
  \makecell{Даты} & \makecell{Дни\\пути} & \makecell{Участки\\маршрута} & \makecell{Протя-\\жённость,\\км*} & \makecell{ЧХВ} & \makecell{Перепад\\высот, м} & \makecell{Определяющие\\препятствия} & \makecell{Погода} \\
  \hline
  \endhead
  \hline \multicolumn{8}{r}{{Продолжение на следующей странице}} \\
  \endfoot
  \hline
  \endlastfoot
}{%
  \end{longtable}
  \endgroup
}

\makeatother

% --------------------------
% КОМАНДА ДЛЯ ОФОРМЛЕНИЯ ДНЯ В ТЕХНИЧЕСКОМ ОПИСАНИИ
% --------------------------
% Создаёт ненумерованный подзаголовок, добавляет его в оглавление
% и, если указан необязательный аргумент, ставит метку для ссылок.
\newcommand{\dayentry}[2][]{%
  \subsection*{#2}%
  \phantomsection
  \addcontentsline{toc}{subsection}{#2}%
  \ifthenelse{\equal{#1}{}}{}{\label{#1}}%
}

% --------------------------
% НАСТРОЙКИ HYPERREF
% --------------------------
\hypersetup{%
  pdftitle={},%
  pdfauthor={},%
  colorlinks=true,%
  linkcolor=black,%
  citecolor=black,%
  urlcolor=black%
}

\endinput