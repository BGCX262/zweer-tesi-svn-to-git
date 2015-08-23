% -*- LaTeX -*-
%
% A LaTeX class for slides
%
% Typesetting options:
% - slides/handout/notes
%   Decide which overlays should be shown.
% - 17pt/20pt/25pt/30pt
%   Font size.
% - blue, red, grey, brown
%   Color of structure symbols
%
% Opzioni font:
% Opzione      Font default     Font sans-serif   Font teletype   Font math
% serif        Palatino         Avant Garde       Courier         Palatino
% avant        Avant Garde      Avant Garde       Courier         Avant Garde
% cmss         CM Sans-Serif    CM Sans-Serif     CM Teletype     CM Sans-Serif
% cmr          CM Roman         CM Sans-Serif     CM Teletype     CM Roman
% cm (default) CM Sans-Serif    CM Sans-Serif     CM Teletype     CM Roman
% aess         AE Sans-Serif    AE Sans-Serif     AE Teletype     AE Sans-Serif
% aer          AE Roman         AE Sans-Serif     AE Teletype     AE Roman
% ae           AE Sans-Serif    AE Sans-Serif     AE Teletype     AE Roman
%

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{tothepoint}[2003/08/13 Slideshow]

\newif\ifttp@slides\ttp@slidestrue
\newif\ifttp@notes\ttp@notesfalse

\newif\ifttp@rm\ttp@rmfalse
\newif\ifttp@mathrm\ttp@mathrmtrue
\newif\ifttp@loadpalatino\ttp@loadpalatinofalse
\newif\ifttp@loadavant\ttp@loadavantfalse
\newif\ifttp@loadcourier\ttp@loadcourierfalse
\newif\ifttp@loadae\ttp@loadaefalse

% Font options
\DeclareOption{serif}{\ttp@loadpalatinotrue\ttp@loadavanttrue\ttp@rmtrue}
\DeclareOption{avant}{\ttp@loadcouriertrue\ttp@loadavanttrue\ttp@mathrmfalse}
\DeclareOption{cmss}{\ttp@mathrmfalse}
\DeclareOption{cmr}{\ttp@rmtrue}
\DeclareOption{cm}{}
\DeclareOption{aess}{\ttp@loadaetrue\ttp@mathrmfalse}
\DeclareOption{aer}{\ttp@loadaetrue\ttp@rmtrue}
\DeclareOption{ae}{\ttp@loadaetrue}

% Mode options.
\DeclareOption{slides}{}
\DeclareOption{handout}{\ttp@slidesfalse}
\DeclareOption{notes}{\ttp@slidesfalse\ttp@notestrue}

% Declare the standard LaTeX options.
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}

% Disable some options.
\DeclareOption{a4paper}%
   {\ClassWarningNoLine{tothepoint}{No slides options for paper.}}
\DeclareOption{a5paper}%
   {\ClassWarningNoLine{tothepoint}{No slides options for paper.}}
\DeclareOption{b5paper}%
   {\ClassWarningNoLine{tothepoint}{No slides options for paper.}}
\DeclareOption{letterpaper}%
   {\ClassWarningNoLine{tothepoint}{No slides options for paper.}}
\DeclareOption{legalpaper}%
   {\ClassWarningNoLine{tothepoint}{No slides options for paper.}}
\DeclareOption{executivepaper}%
   {\ClassWarningNoLine{tothepoint}{No slides options for paper.}}

\DeclareOption{10pt}{%
    \ClassWarningNoLine{tothepoint}{No '10pt' slides option, try shortform,
    17pt, 20pt, 25pt or 30pt (defaulting to 20pt).}}
\DeclareOption{11pt}{%
    \ClassWarningNoLine{tothepoint}{No '11pt' slides option, try shortform,
    17pt, 20pt, 25pt or 30pt (defaulting to 20pt).}}
\DeclareOption{12pt}{%
    \ClassWarningNoLine{tothepoint}{No '12pt' slides option, try shortform,
    17pt, 20pt, 25pt or 30pt (defaulting to 20pt).}}
\DeclareOption{oneside}{}
\DeclareOption{twoside}{%
    \ClassWarningNoLine{tothepoint}{No 'twoside' option for slides.}}
\DeclareOption{openright}{%
    \ClassWarningNoLine{tothepoint}{No 'openright' option for slides.}}
\DeclareOption{openany}{%
    \ClassWarningNoLine{tothepoint}{No 'openany' option for slides.}}
\DeclareOption{titlepage}{}
\DeclareOption{notitlepage}{%
    \ClassWarningNoLine{tothepoint}{No 'notitlepage' option for slides.}}
\DeclareOption{onecolumn}{}
\DeclareOption{twocolumn}{%
    \ClassWarningNoLine{tothepoint}{No 'twocolumn' layout for slides.}}


\newcommand\@ptsize{}
% Declare additional options for large font sizes.  For handouts,
% we work at magnification 0.5.
\DeclareOption{17pt}{\renewcommand\@ptsize{17}}
\DeclareOption{20pt}{\renewcommand\@ptsize{20}}
\DeclareOption{25pt}{\renewcommand\@ptsize{25}}
\DeclareOption{30pt}{\renewcommand\@ptsize{30}}

% Color options.

\DeclareOption{blue}{\def\ttp@themecolor{\definecolor{structure}{rgb}{0.2,0.2,0.7}}}
\DeclareOption{red}{\def\ttp@themecolor{\definecolor{structure}{rgb}{0.7,0.2,0.2}}}
\DeclareOption{grey}{\def\ttp@themecolor{\definecolor{structure}{rgb}{0.2,0.2,0.2}}}
\DeclareOption{brown}{\def\ttp@themecolor{\definecolor{structure}{rgb}{0.66,0.4,0.166}}}

\ExecuteOptions{20pt,final,blue}
\ProcessOptions

%
\RequirePackage{verbatim}
\RequirePackage{graphicx}
\RequirePackage{pifont}
\RequirePackage{color}
\PassOptionsToPackage{colorlinks=true}{hyperref}
\PassOptionsToPackage{breaklinks=true}{hyperref}
\PassOptionsToPackage{draft=false}{hyperref}

\ifx\pdfpagewidth\undefined
\PassOptionsToPackage{dvips}{hyperref}
\else
\PassOptionsToPackage{pdftex}{hyperref}
\fi

%-----------------------------------------------------------------
% Set up fonts.

% Two small shortcut macros...
\def\if@eequal#1#2#3#4{%
  \edef\@tempa{#1}\edef\@tempb{#2}%
  \ifx\@tempa\@tempb#3\else#4\fi}

\def\if@equal#1#2#3#4{%
  \def\@tempa{#1}\def\@tempb{#2}%
  \ifx\@tempa\@tempb#3\else#4\fi}

% First of all, load SliTeX's font definitions and set up FoilTeX's math sizes.
\input{sfonts.def}
\newcommand\@xii@ipt{12.1}
\newcommand\@xiv@vpt{14.5}
\newcommand\@xvii@iiipt{17.38}
\newcommand\@xxxpt{29.86}
\newcommand\@xxxvipt{35.83}
\newcommand\@xliiipt{43}
\newcommand\@lipt{51.60}
\DeclareMathSizes{\@xiipt}{\@xii@ipt}{\@xii@ipt}{\@xii@ipt}
\DeclareMathSizes{\@xivpt}{\@xiv@vpt}{\@xii@ipt}{\@xii@ipt}
\DeclareMathSizes{\@xviipt}{\@xvii@iiipt}{\@xii@ipt}{\@xii@ipt}
\DeclareMathSizes{\@xxpt}{\@xxpt}{\@xiv@vpt}{\@xii@ipt}
\DeclareMathSizes{\@xxvpt}{\@xxvpt}{\@xvii@iiipt}{\@xiv@vpt}
\DeclareMathSizes{\@xxxpt}{\@xxxpt}{\@xxpt}{\@xvii@iiipt}
\DeclareMathSizes{\@xxxvipt}{\@xxxvipt}{\@xxvpt}{\@xxpt}
\DeclareMathSizes{\@xliiipt}{\@xliiipt}{\@xxxpt}{\@xxvpt}
\DeclareMathSizes{\@lipt}{\@lipt}{\@xxxvipt}{\@xxxpt}
\input{size\@ptsize.clo}

% Load required packages.
\ifttp@loadae
 \RequirePackage[slides]{ae}
 \RequirePackage{aeguill}
\else\fi

% Undo roman font changes made by ae and set the correct sans-serif font.
\if@eequal\rmdefault{laess}{\global\def\rmdefault{aer}}{}
\if@eequal\rmdefault{aer}{\global\def\sfdefault{laess}}{}
\if@eequal\rmdefault{cmr}{\global\def\sfdefault{lcmss}}{}

% Load the PFNFSS fonts if reqeuested.
\ifttp@loadpalatino\RequirePackage{palatino}\RequirePackage{mathpple}\else\fi
\ifttp@loadavant\RequirePackage{avant}\else\fi
\ifttp@loadcourier\RequirePackage{courier}\else\fi

% Pick required math fonts.
\ifttp@mathrm
\SetSymbolFont{operators}{normal}{OT1}\rmdefault{m}{n}
\SetSymbolFont{operators}{bold}{OT1}\rmdefault{bx}{n}
\else
\SetSymbolFont{operators}{normal}{OT1}\sfdefault{m}{n}
\SetSymbolFont{operators}{bold}{OT1}\sfdefault{bx}{n}
\fi

% Do use sans-serif fonts if required.
\ifttp@rm\else\let\rmdefault\sfdefault\fi

% Use italics, not slants.
\def\itdefault{it}

% Reset the default font.
\def\familydefault{\rmdefault}

%-----------------------------------------------------------------
% Template settings, commons to slides and handouts.

\renewcommand{\sectionmark}[1]{%
  \markboth{#1}{#1}%
  \global\def\ttp@thissection{#1}%
  \global\def\ttp@thissubsection{#1}%
}
\renewcommand{\subsectionmark}[1]{%
  \markright{#1}%
  \global\def\ttp@thissubsection{#1}%
}

% For headers and footers, you can redefine the \headerstyle and \footerstyle
% commands, which accept the title and number of the slide (the latter is
% accessible with \theslide as well), and the number of the overlay (also
% accessible with \theoverlay).

\def\headerstyle#1#2#3{#1\hfill #2\par}
\def\footerstyle#1#2#3{}

% For environments, you can redefine \blockstyle, which accepts the title
% of the environment.
\def\blockstyle#1{\medskip{\color{structure}\textbf{#1}}\par\medskip}
\def\endblockstyle{}

% If you redefine labelitemi..iv, remember to add \structurestyle as we do.
% Defaults are: `yes' dingbat, right triangle, en-dash, centered period.

\def\labelitemi{\structurestyle{\ding{51}}}
\def\labelitemii{\structurestyle{$\triangleright$}}
\def\labelitemiii{\structurestyle{\normalfont\bfseries \textendash}}
\def\labelitemiv{\structurestyle{\textperiodcentered}}

% For colors, redefine \alertstyle and \structurestyle.  By default they
% are red and blue (the latter modifiable via options), respectively.

\ttp@themecolor
\def\structurestyle#1{{\color{structure}#1}}
\def\alertstyle#1{{\color{red}#1}}

% To redefine the appearance of the title page you can use \titlestyle,
% which accepts the title, author, and date, since these are uneasy to
% access from the document preamble (you need \makeatletter) to do that.

\def\titlestyle#1#2#3{%
#1\\
\footnotesize #2, #3}

\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}

\def\maketitle{%
  \begin{titleslide}
  \null
  \titlestyle{\@title}{\@author}{\@date}
  \end{titleslide}
}

\AtBeginDocument{\raggedright}

%-----------------------------------------------------------------
% Table of contents & sectioning.

% Alcuni comandi sono definiti solo per poter usare renewcommand sotto,
% altri sono copiati da article.cls

\newcounter{section}
\newcounter{subsection}[section]

\renewcommand\thesection{\arabic{section}}
\renewcommand\thesubsection{\thesection.\arabic{subsection}}

\setcounter{tocdepth}{3}
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}

\newcommand{\section}[2][\null]{%
\if@equal{#1}{\null}{\ttp@section{#2}{#2}}{\ttp@section{#1}{#2}}}

\newcommand{\ttp@section}[2]{%
  \refstepcounter{section}%
  \sectionmark{#1}%
  \addcontentsline{toc}{section}{#2}%
  \ignorespaces}

\newcommand{\subsection}[2][\null]{%
\if@equal{#1}{\null}{\ttp@subsection{#2}{#2}}{\ttp@subsection{#1}{#2}}}

\newcommand{\ttp@subsection}[2]{%
  \refstepcounter{subsection}%
  \subsectionmark{#1}%
  \addcontentsline{toc}{subsection}{#2}%
  \ignorespaces}

% Reads the toc into a global register, since we need it many times.
% There is some complication because of the extra argument that is
% introduced by the hyperref package.  \ttp@tocappend is easier
% than it seems: \expandafter saves the {, then it expands
% \the\ttp@toccontents, and finally puts back the brace.  This way,
% the expansion of \the\ttp@toccontents and #1 are concatenated
% together to form the new \ttp@toccontents.

\newif\ifttp@tocfound
\newtoks\ttp@toccontents

\def\ttp@tocappend#1{
  \global\ttp@tocfoundtrue
  \global\ttp@toccontents\expandafter{\the\ttp@toccontents#1}}

\AtBeginDocument{
  \ifx\hyper@anchor\@undefined
    \def\ttp@contentsline#1#2#3{
      \ttp@tocappend{\contentsline{#1}{#2}{#3}}}
  \else
    \def\ttp@contentsline#1#2#3#4{
      \ttp@tocappend{\contentsline{#1}{#2}{#3}{#4}}}
  \fi
}

% Included in \begingroup...\endgroup so that we can redefine
% \contentsline.
\def\ttp@readtoc{
  \global\ttp@toccontents={}%
  \begingroup%
    \let\contentsline\ttp@contentsline%
    \@starttoc{toc}%
  \endgroup%
  \global\let\ttp@readtoc\relax%
}

% Use the contents of the \ttp@toccontents register to print
% a TOC for sections.  Subsections are skipped, they are a
% task for \subtableofcontents.

\def\tableofcontents{%
  \def\l@section##1##2{\item ##1}%
  \def\l@subsection##1##2{}%
  \begin{singleslide}[\contentsname]
  \ttp@readtoc\ifttp@tocfound
    \begin{itemize}
    \the\ttp@toccontents
    \end{itemize}
  \fi
  \end{singleslide}
}

% Use the contents of the \ttp@toccontents register to print
% a TOC for the current section.  Again, reuse the \ttp@toccontents
% register. The \l@subsection definition will be switched so that
% it emits subsections for the matched section, and skips subsections
% for other sections.

\def\subtableofcontents{%
  \def\l@othersubsection##1##2{}%
  \def\l@thissubsection##1##2{\item ##1}%
  \def\ttp@dummy@linkstart##1##2##3\hyper@linkend{##3}%
  \def\l@section##1##2{%
    \begingroup%
    \let\hyper@linkstart\ttp@dummy@linkstart%
    \if@eequal{##1}{\ttp@thissection}%
      {\global\let\l@subsection\l@thissubsection}%
      {\global\let\l@subsection\l@othersubsection}%
    \endgroup}%
  \begin{singleslide}[\ttp@thissection]
  \ttp@readtoc\ifttp@tocfound
    \begin{itemize}
    \the\ttp@toccontents
    \end{itemize}
  \fi
  \end{singleslide}
}

% ---------------------------------------------------
% Overlay commands: saving and restoring overlays

% Define the counters that we need.

\newcounter{ttp@slide}
\newcounter{ttp@overlay}
\newcounter{ttp@ovmax}
\newwrite\ttp@scribble

\def\theslide{\arabic{ttp@slide}}
\def\theoverlay{\alph{ttp@overlay}}
\let\thepage\theslide

% Since slide makes funny games with verbatim it is not usable
% from within commands.  All these, however, can.
\newif\ifttp@hastitle
\newenvironment{overlaygroup}[1][\ttp@thissubsection]{%
  \stepcounter{ttp@slide}%
  \setcounter{ttp@ovmax}{1}%
  \setcounter{ttp@overlay}{0}%
  \if@equal{#1}{}%
    {\global\def\ttp@slidetitle{}\global\ttp@hastitlefalse}%
    {\global\def\ttp@slidetitle{#1}\global\ttp@hastitletrue}%
}{}

\newenvironment{singleslide}[1][\ttp@thissubsection]{%
  \overlaygroup[#1]
  \begin{overlay}
}{
  \end{overlay}
  \endoverlaygroup
}

\newenvironment{titleslide}{%
  \begin{overlaygroup}[]
  \begin{overlay}
}{
  \end{overlay}
  \end{overlaygroup}
  \addtocounter{ttp@slide}{-1}%
}

% This is based on the verbatimwrite environment found in the
% documentation for the verbatim package.  Since we have an
% optional argument, however, we should change the catcode of ^^M
% before processing it: otherwise \@ifnextchar supplies \verbatim@start
% with an inactive ^^M and the damn thing does not work.

\def\slide{
  \begingroup%
  \@bsphack%
  \catcode`\^^M\active%
  \@slide}

\newcommand{\@slide}[1][\ttp@thissubsection]{
  \overlaygroup[#1]%
  \immediate\openout\ttp@scribble=\jobname.tmp%
  \immediate\write\ttp@scribble{\csname begin \endcsname{overlay}}
  \let\do\@makeother\dospecials%
  \def\verbatim@processline{\immediate\write\ttp@scribble{\the\verbatim@line}}%
  \verbatim@start%
}

\def\endslide{%
  \immediate\write\ttp@scribble{\csname end \endcsname{overlay}}
  \immediate\closeout\ttp@scribble%
  \@esphack%
  \endgroup%
  \ttp@dooverlays
  \endoverlaygroup
}

% Recursively emit all the overlays in the slide; for handouts/notes,
% \alt takes care of emitting everything, and we don't recurse here.

\def\ttp@dooverlays{%
  \ifnum \value{ttp@overlay}<\value{ttp@ovmax}%
    \stepcounter{ttp@overlay}%
    \input{\jobname.tmp}%
    \ifttp@slides%
      \ifnum \value{ttp@ovmax}>1%
        \immediate\typeout{Wrote overlay \arabic{ttp@overlay}/\arabic{ttp@ovmax}}%
      \fi%
      \ttp@dooverlays%
    \fi%
  \fi%
}

% ---------------------------------------------------
% Overlay commands: defining overlay commands.
% Taken from beamer.cls.

% Helper macro for overlays
\def\original#1{\csname @orig\string#1\endcsname}

% In disabled slides, #1 does #2, otherwise #3
\long\def\newoverlaycommand#1#2#3{
  \def#1{\@ifnextchar <{\@overlayparse{#2}{#3}}{#2}}%
}

% In disabled slides, #1 does #2, otherwise #3
\long\def\renewoverlaycommand#1#2#3{
  \edef\@name{\original#1}
  \expandafter\let\@name=#1\relax%
  \newoverlaycommand{#1}{#2}{#3}%
}

\long\def\@overlayparse#1#2<#3>{\alt<#3>{#1}{#2}}

\def\newoverlayenvironment#1{%
  \@ifnextchar[{\@@newoverlayenvironment{#1}}{\@newoverlayenvironment{#1}}}

% In disabled slides, #1 forms an
% environment with begin #2 and end #3, otherwise an environment with 
% begin #4 and end #5
\long\def\@newoverlayenvironment#1#2#3#4#5{
  \newenvironment{#1}{}{}%
  \expandafter\def\csname #1\endcsname{%
    \@ifnextchar<{\@parsebegin{#1}{#2}{#3}{#4}{#5}}{%
      \expandafter\def\csname end#1\endcsname{#3}#2}}%
  }
    
% Helper macro for renewoverlayenvironment
\long\def\@parsebegin#1#2#3#4#5<#6>{%
  \alt<#6>{% In slide case
    \expandafter\def\csname end#1\endcsname{#3}%
    #2}{%
    \expandafter\def\csname end#1\endcsname{#5}%
    #4}}

\long\def\renewoverlayenvironment#1#2#3#4#5{%
  \edef\@do{\csname original#1\endcsname=\expandafter\noexpand\csname#1\endcsname}
  \expandafter\let\@do
  \edef\@do{\csname endoriginal#1\endcsname=\expandafter\noexpand\csname end#1\endcsname}
  \expandafter\let\@do
  \renewenvironment{#1}{}{}%
  \expandafter\def\csname #1\endcsname{%
    \@ifnextchar<{\@parsebegin{#1}{#2}{#3}{#4}{#5}}{%
      \expandafter\def\csname end#1\endcsname{#3}#2}%
    }%
  }

\long\def\@@newoverlayenvironment#1[1]#2#3#4#5{% Currently, this works
% only for a single argument
  \newenvironment{#1}{}{}%
  \expandafter\new@command\csname @in#1\endcsname[1]{#2}%
  \expandafter\new@command\csname @out#1\endcsname[1]{#4}%
  \expandafter\def\csname #1\endcsname##1{%
    \@ifnextchar<{\@parsebegin{#1}{\csname @in#1\endcsname{##1}}{#3}{\csname @out#1\endcsname{##1}}{#5}}{%
      \expandafter\def\csname end#1\endcsname{#3}#2}}%
  }

% Define overlay commands

\def\gobble#1{}
\long\def\@gobbleopt{\@ifnextchar[{\@@gobbleopt}{}}
\long\def\@@gobbleopt[#1]{}
\long\def\@gobbletwooneopt{\@ifnextchar[{\@@gobbletwooneopt}{\@gobble}}
\long\def\@@gobbletwooneopt[#1]#2{}

\newsavebox{\ttp@phantomenvbox}
\newcounter{ttp@nestedphantomenvs}

\newenvironment{phantomenv}{%
  \addtocounter{ttp@nestedphantomenvs}{1}%
  \ifnum \value{ttp@nestedphantomenvs}=1%
    \begin{lrbox}{\ttp@phantomenvbox}
  \fi}{%
  \addtocounter{ttp@nestedphantomenvs}{-1}%
  \ifnum \value{ttp@nestedphantomenvs}=0%
    \end{lrbox}\phantom{\usebox{\ttp@phantomenvbox}}%
  \fi}

\newoverlaycommand{\only}{}{\gobble}
\newoverlaycommand{\uncover}{}{\phantom}
\newoverlaycommand{\transition}{\ttp@checktransition}{\gobble}
\renewoverlaycommand{\textbf}{\original{\textbf}}{}
\renewoverlaycommand{\textit}{\original{\textit}}{}
\renewoverlaycommand{\textsl}{\original{\textsl}}{}
\renewoverlaycommand{\textsf}{\original{\textsf}}{}
\renewoverlaycommand{\textrm}{\original{\textrm}}{}
\renewoverlaycommand{\emph}{\original{\emph}}{}
\renewoverlaycommand{\color}{\original{\color}}{\gobbletwooneopt}
\newoverlayenvironment{uncoverenv}{}{}{\phantomenv}{\endphantomenv}
\newoverlayenvironment{onlyenv}{}{}{\comment}{\endcomment}

% To make item overlays, wrap them into an uncoverenv

\let\@origitem=\item
\long\def\item{%
  \@ifnextchar<{\@closeitem\@parseitem}{\@closeitem\@origitem}}
\global\def\@closeitem{}
\def\@parseitem<#1>{%
  \alt<#1>{\@origitem}{%
    \global\def\@closeitem{\endphantomenv\global\def\@closeitem{}}%
    \@origitem[~]\phantomenv\@gobbleopt}}

% Fire the last \@closeitem on \endlist.

\let\@origlist=\list
\let\@origendlist=\endlist

\def\list{%
  \global\let\@savedcloseitemiii\@savedcloseitemii%
  \global\let\@savedcloseitemii\@savedcloseitemi%
  \global\let\@savedcloseitemi\@savedcloseitem%
  \global\let\@savedcloseitem\@closeitem%
  \global\def\@closeitem{}%
  \@origlist}

\def\endlist{%
  \@closeitem%
  \global\let\@closeitem\@savedcloseitem%
  \global\let\@savedcloseitem\@savedcloseitemi%
  \global\let\@savedcloseitemi\@savedcloseitemii%
  \global\let\@savedcloseitemii\@savedcloseitemiii%
  \@origendlist}

\let\endenumerate\endlist
\let\enditemize\endlist

% ---------------------------------------------------
% Overlay commands: interpreting overlay sequences.
% This magic does not come from beamer.cls instead :-)

\newcounter{ttp@ovfirst}
\newcounter{ttp@ovlast}

% \ttp@decodeoverlay is below.  \ttp@ovhook receives the first and last
% overlay, and the command to continue parsing (\decodeoverlay or
% \ttp@ovend).  The ttp@ovmax counter receives the correct value after the
% end of the first overlay.
\long\def\alt<#1>#2#3{%
  \def\ttp@dowhat{#3}%
  \def\ttp@doit{#2}%
  %
  % First find the maximum overlay.
  \def\ttp@ovhook##1##2##3{%
    \ifnum \value{ttp@ovmax}<##1\setcounter{ttp@ovmax}{##1}\else\fi%
    \ifnum \value{ttp@ovmax}<##2\setcounter{ttp@ovmax}{##2}\else\fi%
    ##3}%
  \def\ttp@ovend{}%
  \ttp@decodeoverlay<#1>%
  %
  % Decode again to pick the correct alternative and then do it in \ttp@ovend.
  \def\ttp@ovhook##1##2##3{%
    \ifttp@slides%
    \ifnum\value{ttp@overlay}<##1\else%
    \ifnum\value{ttp@overlay}>##2\else%
    \let\ttp@dowhat\ttp@doit\fi\fi%
    \else\let\ttp@dowhat\ttp@doit\fi%
    ##3}%
  \def\ttp@ovend{\ttp@dowhat}%
  \ttp@decodeoverlay<#1>}

% A simple LL(1) parser. #1 is the current token, #2 is the lookahead.

\def\ttp@decodeoverlay#1#2{%
  \setcounter{ttp@ovfirst}{1}%
  \ifx#2-\let\do\ttp@decodeminus \else \let\do\ttp@decodefirst \fi%
  \do #2}

\def\ttp@decodefirst#1#2{%
  \setcounter{ttp@ovfirst}{#1}%
  \setcounter{ttp@ovlast}{#1}%
  \let\do\ttp@decodeerror%
  \ifx#2>\let\do\ttp@decodeend \else \fi%
  \ifx#2-\let\do\ttp@decodeminus \else \fi%
  \ifx#2,\let\do\ttp@decodecomma \else \fi%
  \do #2}

\def\ttp@decodeminus#1#2{%
  \setcounter{ttp@ovlast}{\value{ttp@ovmax}}%
  \let\do\ttp@decodelast%
  \ifx#2>\let\do\ttp@decodeend \else \fi%
  \ifx#2,\let\do\ttp@decodecomma \else \fi%
  \do #2}

\def\ttp@decodelast#1#2{%
  \setcounter{ttp@ovlast}{#1}%
  \let\do\ttp@decodeerror%
  \ifx#2>\let\do\ttp@decodeend \else \fi%
  \ifx#2,\let\do\ttp@decodecomma \else \fi%
  \do #2}

% Try to recover...
\def\ttp@decodeerror#1{%
  \ClassError{tothepoint}{Bad overlay specification, found #1 after number}{}%
  \let\do\ttp@decodeerror%
  \ifx#1>\let\do\ttp@decodeend \else \fi%
  \ifx#1-\let\do\ttp@decodeminus \else \fi%
  \ifx#1,\let\do\ttp@decodecomma \else \fi%
  \do #1}

% Invoke the hook and call \ttp@decodeoverlay to swallow the ,
\def\ttp@decodecomma{%
  \ttp@ovhook{\value{ttp@ovfirst}}{\value{ttp@ovlast}}{\ttp@decodeoverlay}%
}

% Invoke the two hooks
\def\ttp@decodeend#1{%
  \ttp@ovhook{\value{ttp@ovfirst}}{\value{ttp@ovlast}}{\ttp@ovend}%
}

%-----------------------------------------------------------------
% Slideshow settings.

% Imposta la pagina in rapporto 4:3 con dimensioni paragonabili a un foglio A4.
\setlength\paperheight{21cm}
\setlength\paperwidth{28cm}
\ifx\pdfpagewidth\undefined
\AtBeginDvi{\special{papersize=\the\paperwidth,\the\paperheight}}
\AtBeginDvi{\special{! TeXDict begin /landplus90{true}store end }}
\else
\setlength{\pdfpagewidth}{\paperwidth}
\setlength{\pdfpageheight}{\paperheight}
\fi

%\setlength\marginparwidth{54pt}
%\setlength\marginparsep{10pt}
%\setlength\marginparpush{5pt}

\newenvironment{overlay}{
\ttp@dotransition}{
\newpage}

%-----------------------------------------------------------------
% Notes settings.

\ifttp@notes
\newenvironment{notes}{\newpage}{}
\else
\newenvironment{notes}{\comment}{\endcomment}
\fi

% --------------------------------------------------
% PDF settings.

% By default: cropping to a4 paper dimensions
\def\pdfcroppingbox{0 0 890 595}
\ifx\pdfpagewidth\undefined
\else
  \AtBeginDocument{%
    \ifx\hypersetup\undefined\else%
      \hypersetup{pdfpagescrop=\pdfcroppingbox}%
    \fi}%
\fi

% Helper macros for \transition
% Transition from one page to another. Possible values:
% Split, Blinds, Box, Wipe, Dissolve, Glitter, R, Replace

% These macros define ttp@dotransition, which is invoked
% from the overlay environment.
\def\ttp@deftrans#1{%
  \global\def\ttp@dotransition{%
    \ifx\hypersetup\undefined\else\hypersetup{pdfpagetransition=#1}\fi%
    \ttp@trans@Replace}}

\def\ttp@trans@Split{\ttp@deftrans{Split}}
\def\ttp@trans@SplitHO{\ttp@deftrans{Split /Dm /H /M /O}}
\def\ttp@trans@SplitHI{\ttp@deftrans{Split /Dm /H /M /I}}
\def\ttp@trans@SplitVO{\ttp@deftrans{Split /Dm /V /M /O}}
\def\ttp@trans@SplitVI{\ttp@deftrans{Split /Dm /V /M /I}}
\def\ttp@trans@Blinds{\ttp@deftrans{Blinds}}
\def\ttp@trans@BlindsH{\ttp@deftrans{Blinds /Dm /H}}
\def\ttp@trans@BlindsV{\ttp@deftrans{Blinds /Dm /V}}
\def\ttp@trans@Box{\ttp@deftrans{Box}}
\def\ttp@trans@BoxO{\ttp@deftrans{Box /M /O}}
\def\ttp@trans@BoxI{\ttp@deftrans{Box /M /I}}
\def\ttp@trans@Dissolve{\ttp@deftrans{Dissolve}}
\def\ttp@trans@R{\ttp@deftrans{Replace}}
\def\ttp@trans@Replace{\ttp@deftrans{Replace}}
\def\ttp@trans@Wipe{\ttp@deftrans{Wipe}}
%\def\ttp@trans@Wipe0{\ttp@deftrans{Wipe /Di /0}}
%\def\ttp@trans@Wipe90{\ttp@deftrans{Wipe /Di /90}}
%\def\ttp@trans@Wipe180{\ttp@deftrans{Wipe /Di /180}}
%\def\ttp@trans@Wipe270{\ttp@deftrans{Wipe /Di /270}}
\def\ttp@trans@Glitter{\ttp@deftrans{Glitter}}
%\def\ttp@trans@Glitter0{\ttp@deftrans{Glitter /Di /0}}
%\def\ttp@trans@Glitter90{\ttp@deftrans{Glitter /Di /90}}
%\def\ttp@trans@Glitter180{\ttp@deftrans{Glitter /Di /180}}
%\def\ttp@trans@Glitter270{\ttp@deftrans{Glitter /Di /270}}

% This macro checks the validity of the supplied transition,
% and if so, it sets it up.
\def\ttp@checktransition#1{%
  \toks@{}
  \expandafter\ifx\csname ttp@trans@#1\endcsname\undefined%
    \ClassError{tothepoint}{Undefined transition #1}{%
      Possible values: Split, Blinds, Box, Wipe, Dissolve, Glitter, R}%
  \else%
    \toks@{\csname ttp@trans@#1\endcsname}%
  \fi%
  \the\toks@%
}

% Set the default transition
\ttp@trans@Replace

% --------------------------------------------------
% Other commands

% Translation
\newcommand{\contentsname}{Outline}

% Redefine underlining so that the width depends on the font size
\renewcommand\_{\leavevmode\kern.06em\vbox{\hrule width.4em height.12ex}}

% Define \onslides and \onhandout
\ifttp@slides
\let\onslides\only
\let\onhandout\gobble
\else
\let\onhandout\gobble
\let\onslides\only
\fi

% No need to be fussy in slides!
\sloppy

% Alert
\newoverlaycommand{\alert}{\alertstyle}{}

% Insert area

\newbox\ttp@areabox
\newdimen\ttp@finalheight
\newenvironment{overlayarea}[2]{%
  \ttp@finalheight=#2\relax%
  \advance\ttp@finalheight by-\baselineskip%
  \setbox\ttp@areabox=\hbox\bgroup%
  \begin{minipage}[t]{#1}%
  }
  {
  \end{minipage}%
  \egroup%
  \ht\ttp@areabox=0pt%
  \dp\ttp@areabox=\finalheight%
  \box\ttp@areabox%
}

% Blocks

\newsavebox{\ttp@blockenvbox}
\newoverlayenvironment{block}[1]%
    {\par\blockstyle{#1}}{\par\endblockstyle}%
    {\begin{lrbox}{\ttp@blockenvbox}\par\blockstyle{#1}}%
    {\par\endblockstyle\end{lrbox}\phantom{\usebox{\ttp@blockenvbox}}}

\newenvironment{definition}{\begin{block}{Definition}}{\end{block}}
\newenvironment{definitions}{\begin{block}{Definitions}}{\end{block}}
\newenvironment{theorem}{\begin{block}{Theorem}}{\end{block}}
\newenvironment{proof}{\begin{block}{Proof.}}{\end{block}}
\newenvironment{corollary}{\begin{block}{Corollary}}{\end{block}}
\newenvironment{fact}{\begin{block}{Fact}}{\end{block}}
\newenvironment{example}{\begin{block}{Example}}{\end{block}}

% Columns

\newenvironment{columns}{\leavevmode\hskip-1cm\nobreak\hbox to\paperwidth\bgroup
\hbox{}\hfill\ignorespaces}{\egroup\nobreak\hskip-1cm}
\newenvironment{columnsonlytextwidth}{\leavevmode\hbox to\textwidth\bgroup\ignor
espaces}{\unskip\egroup}

\newenvironment{column}[1]{%
  \begin{minipage}[c]{#1}%
  \raggedright}
  {\end{minipage}\hfill\ignorespaces}

\newcommand{\bottomalign}{\vskip0pt plus 1filll}

% Set up the list environments:: indentation,
\setlength\leftmargini{15pt}
\setlength\leftmarginii{22pt}
\setlength\leftmarginiii{18.7pt}
\setlength\leftmarginiv{17pt}
\setlength\leftmarginv{10pt}
\setlength\leftmarginvi{10pt}
\setlength\leftmargin\leftmargini

% ... labels, ...
\setlength\labelsep{10pt}
\setlength\labelwidth\leftmargini\advance\labelwidth-\labelsep

% ... separations, ...
\setlength\partopsep{2pt plus 1pt minus 1pt}
\newcommand\@listIa{\leftmargin\leftmargini
\topsep 14pt plus 2pt minus 4pt
\parsep 14pt plus 4pt minus 4pt
\itemsep 14pt plus 4pt minus 2pt}
\newcommand\@listIb{\leftmargin\leftmargini
\topsep 8pt plus 2pt minus 2pt
\parsep 2pt plus 1pt minus 1pt
\itemsep \parsep}
\newcommand\@listIc{\leftmargin\leftmargini
\topsep 6pt plus 1pt minus 1pt
\parsep 2pt plus 1pt minus 1pt
\itemsep \parsep}
\newcommand\@listId{\leftmargin\leftmargini
\topsep 4pt plus 1pt minus 1pt
\parsep 2pt plus 1pt minus 1pt
\itemsep \parsep}
\gdef\@listii{\leftmargin\leftmarginii
 \labelwidth\leftmarginii\advance\labelwidth-\labelsep
 \topsep 0pt
 \parsep 0pt
 \itemsep \parsep}
\gdef\@listiii{\leftmargin\leftmarginiii
 \labelwidth\leftmarginiii\advance\labelwidth-\labelsep
 \partopsep 1pt plus 0pt minus 1pt
 \topsep 0pt
 \parsep 0pt
 \itemsep \topsep}
\gdef\@listiv{\leftmargin\leftmarginiv
 \labelwidth\leftmarginiv\advance\labelwidth-\labelsep}
\gdef\@listv{\leftmargin\leftmarginv
 \labelwidth\leftmarginv\advance\labelwidth-\labelsep}
\gdef\@listvi{\leftmargin\leftmarginvi
 \labelwidth\leftmarginvi\advance\labelwidth-\labelsep}

\normalsize
\@listi

% ... counters
\def\theenumi{\arabic{enumi}}
\def\theenumii{\alph{enumii}}
\def\theenumiii{\roman{enumiii}}
\def\theenumiv{\Alph{enumiv}}
\def\p@enumi{}
\def\p@enumii{\theenumi}
\def\p@enumiii{\theenumi(\theenumii)}
\def\p@enumiv{\p@enumiii\theenumiii}
\def\labelenumi{\theenumi.}
\def\labelenumii{(\theenumii)}
\def\labelenumiii{\theenumiii.}
\def\labelenumiv{\theenumiv.}

% ... other environments
\newcommand\descriptionlabel[1]{\hspace\labelsep \normalfont\bfseries #1}
\newenvironment{description}{\list{}{\labelwidth 0pt
  \itemindent-\leftmargin \let\makelabel\descriptionlabel}}{\endlist}
\newenvironment{verse}{\let\\=\@centercr
 \list{}{\itemsep 0pt \itemindent -1.5em\listparindent \itemindent
 \rightmargin\leftmargin\advance\leftmargin 1.5em}\item[]}{\endlist}
\newenvironment{quotation}{\list{}{\listparindent 1.5em
 \itemindent\listparindent
 \rightmargin\leftmargin \parsep 0pt plus 1pt}\item[]}{\endlist}
\newenvironment{quote}{\list{}{\rightmargin\leftmargin}\item[]}{\endlist}

% Fix some settings specially for slides...
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\@beginparpenalty -\@lowpenalty
\@endparpenalty -\@lowpenalty
\@itempenalty -\@lowpenalty
\oddsidemargin 0pt
\evensidemargin 0pt
\arraycolsep 10pt
\tabcolsep 12pt
\arrayrulewidth 1pt
\doublerulesep 3pt
\tabbingsep\labelsep
\fboxsep 10pt
\fboxrule 1pt

\newbox\ttp@headbox
\newbox\ttp@footbox
\newcommand{\ps@ttp}{%
  \global\def\@oddhead{%
    \ifttp@hastitle\headerstyle{\ttp@slidetitle}{\theslide}{\theoverlay}\fi}%
  \global\def\@oddfoot{\vbox{%
    \vskip 1em
    \ifttp@hastitle\footerstyle{\ttp@slidetitle}{\theslide}{\theoverlay}\fi}}%
  \global\let\@evenhead\@oddhead%
  \global\let\@evenfoot\@oddfoot%
}

\newcommand{\ttp@setheadfootheight}[2]{%
  \global\topmargin0pt%
  \global\headsep0pt%
  \global\headheight#1%
  \global\footskip#2%
  \global\advance\footskip by 1em%              Added above
  \global\textheight\paperheight
  \global\advance\textheight by -\headheight%
  \global\advance\textheight by -3cm%
  \global\advance\textheight by -\footskip%
  \global\textwidth\paperwidth
  \global\advance\textwidth by -4cm%
  \global\vsize\textheight%
  \global\hsize\textwidth}

% Keep things in order.
\onecolumn
\mark{{}{}}
\pagestyle{ttp}
\ttp@setheadfootheight{0cm}{0cm}

% Compatibility
\let\tt\texttt
