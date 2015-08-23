%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% --- LaTeX --- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%																		%%
%%	tesi.cls															%%
%%	Niccolò Olivieri 2010												%%
%%																		%%
%%	Ispirato da "thesis.cls" e "tesi.cls" rispettivamente di Livio		%%
%%	Dalloro (2004) e di Paolo Bonzini (2003)							%%
%%																		%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%																		%%
%%	Opzioni:															%%
%%																		%%
%%	- draft / final														%%
%%		draft implica "notitlepage" e "nofullbib", inoltre aggiunge		%%
%%		sulla pagina del titolo (se c'è) e in fondo ad ogni pagina la	%%
%%		data di oggi, con un messaggio che indica che la copia è una 	%%
%%		bozza. Da specificare prima delle altre opzioni perchè 			%%
%%		cambiano alcuni default.										%%
%%																		%%
%%	- english / italian													%%
%%		Definiscono la lingua da passare al Babel e impostano le		%%
%%		traduzioni di alcune stringhe.									%%
%%																		%%
%%	- titlepage / notitlepage											%%
%%		Impostano se omettere l'abstract, la pagina del titolo, la		%%
%%		dedica e i ringraziamenti. Il default è "titlepage" per la 		%%
%%		final e "notitlepage" per la draft.								%%
%%																		%%
%%	- listoffigures - listoftables - listoflistings						%%
%%		Includono dopo l'indice anche l'elenco delle figure, delle		%%
%%		tabelle e dei codici. Se è specificato "notitlepage" vengono 	%%
%%		omessi.															%%
%%																		%%
%%	- bibtex / nobibtex													%%
%%		Controllano se la bibliografia è realizzata con BibTeX o meno.	%%
%%		Influiscono solo sulla formattazione delle citazioni. Il 		%%
%%		default è "nobibtex" perchè non fa danni. ("bibtex" richiede	%%
%%		lo stile plainnat cui fa riferimento nella dichiarazione di		%%
%%		\bibliographystyle)												%%
%%																		%%
%%	- fullbib / nofullbib												%%
%%		Controllano se le voci della bibliografia non citate nel		%%
%%		documento vanno include. Il default è "fullbib" nella copia		%%
%%		final e "nofullbib" in quella draft. Specificare sempre			%%
%%		"nofullbib" è utile se si usa un database BibTeX costruito		%%
%%		indipendentemente dal testo.									%%
%%																		%%
%%																		%%
%%	Opzioni disabilitate:												%%
%%																		%%
%%	- legalpaper														%%
%%	- executivepaper													%%
%%	- a5paper															%%
%%	- b5paper															%%
%%	- twocolumn															%%
%%	- landscape															%%
%%																		%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%																		%%
%%	Ambienti:															%%
%%																		%%
%%	- abstract - dedica - ringraziamenti - sommario						%%
%%		Vengono omessi se è specificata l'opzione "notitlepage" e se	%%
%%		si vogliono dividere i ringraziamenti in più parti basta		%%
%%		specificare l'ambiente più volte.								%%
%%																		%%
%%	- ignore															%%
%%		Un commento, ma con un nome più espressivo.						%%
%%																		%%
%%	- example															%%
%%		Testo "verbatim" con spaziatura singola.						%%
%%																		%%
%%	- listing															%%
%%		Aggiunge un progressivo a sinistra di ogni riga. (è una			%%
%%		semplificazione di lstlisting).									%%
%%																		%%
%%	- initialquote														%%
%%		Si usa per la citazione all'inizio di ogni capitolo.			%%
%%																		%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%																		%%
%%	Comandi:															%%
%%																		%%
%%	- \newtextcommand - \renewtextcommand - \providetextcommand			%%
%%		Definiscono nuovi comandi che aggiungono automaticamente, se	%%
%%		serve, uno spazio dopo di essi. Utile per le abbreviazioni.		%%
%%		Per esempio: \newtextcommand{\csharp}{C$^{\#}$} aggiunge uno	%%
%%		spazio dopo \csharp. Utilizza il package "xspace".				%%
%%																		%%
%%	- \footnoteret														%%
%%		Dato un riferimento interno al documento, genera una nota a		%%
%%		piè di pagina del tipo "vedi 1.1.1". Ha un argomento opzionale	%%
%%		che viene inserito dopo la parola "vedi".						%%
%%																		%%
%%	- \draftnote														%%
%%		Genera testo in corsivo tra quadre. Permette di verificare		%%
%%		facilmente di non aver lasciato note provvisorie nella			%%
%%		versione finale.												%%
%%																		%%
%%	- \strong															%%
%%		Come \textbf ma con un nome più carino.							%%
%%																		%%
%%	- \code																%%
%%		Per default LaTeX non sillaba il testo in \texttt, ma non è 	%%
%%		un'idea geniale, come nemmeno lasciare la spaziatura normale.	%%
%%		Questo comando è uguale a \texttt, ma riabilita la				%%
%%		sillabazione e \frenchspacing, e inoltre si può usare nei		%%
%%		titoli di sezione.												%%
%%																		%%
%%	- \ifpdftex ... \else ... \fi										%%
%%		Espande uno dei due rami a seconda che si stia generando un 	%%
%%		file dvi o pdf.													%%
%%																		%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%																		%%
%%	Struttura del documento finale:										%%
%%																		%%
%%	\documentclass{tesi}												%%
%%	\begin{document}													%%
%%	\author{ ... }														%%
%%	\title{ ... }														%%
%%	\anno{ ... }														%%
%%	\matricola{ ... }													%%
%%	\relatore{ ... }													%%
%%	\correlatore{ ... }			% può essere omesso						%%
%%	\universita[logo]{ università }{ facoltà }{ corso di laurea }		%%
%%	\frontmatter														%%
%%					abstract, dedica, ringraziamenti e sommario			%%
%%	\mainmatter															%%
%%						testo dei vari capitoli							%%
%%	\backmatter															%%
%%						bibliografia e indici							%%
%%	\end{document}														%%
%%																		%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%																		%%
%%	La bibliografia, ovvero natbib in pillole:							%%
%%																		%%
%%	Se si specifica l'opzione bibtex, questa classe utilizza un ottimo	%%
%%	package per personalizzare la bibliografia, chiamato natbib.  In	%%
%%	breve, questo definisce tre comandi per le citazioni:				%%
%%																		%%
%%	\citep       (Pinco e Pallino, 1988)								%%
%%	              da utilizzare quando la citazione non interrompe il	%%
%%	              flusso della frase									%%
%%																		%%
%%	\citeauthor  Pinco e Pallino										%%
%%	             da utilizzare per formule come "Secondo Pinco e		%%
%%	             Pallino..."											%%
%%																		%%
%%	\citet       Pinco e Pallino (1988)									%%
%%	             da utilizzare quando la citazione è il soggetto di una	%%
%%	             frase, come in "Pinco e Pallino (1988) spiega che..."	%%
%%																		%%
%%	\citeyearpar (1988)													%%
%%	             da utilizzare quando il nome si trova in un'altra		%%
%%	             parte della frase (di solito citato con \citeauthor),	%%
%%	             come in "Pinco e Pallino affermano (1988):..."			%%
%%																		%%
%%	Questi comandi ammettono argomenti opzionali, quindi le sintassi	%%
%%	possibili sono due:													%%
%%																		%%
%%	\cite{label}              per citare tutto il testo					%%
%%	\cite[capitolo 15]{label} per citare una parte del testo, 			%%
%%	                          nell'esempio il solo capitolo 15.			%%
%%																		%%
%%	Se non si specifica l'opzione bibtex viene invece utilizzato		%%
%%	l'ordinamento numerico.  Continuano a essere disponibili gli stessi	%%
%%	comandi, ma invece che \citep o \citet è possibile utilizzare		%%
%%	sempre \cite, a causa dello stile diverso delle citazioni.			%%
%%																		%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{tesi}[2010/10/27 Tesi di Laurea]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Per prima cosa definiamo i comandi a "basso livello", dato che ci 	%%
%%	servono in seguito e che le loro definizioni non dipendono da 		%%
%%	nessun package aggiuntivo.											%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	\ifpdftex															%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifpdftex\pdftexfalse
\begingroup\expandafter\expandafter\expandafter\endgroup
\expandafter\ifx\csname pdfoutput\endcsname\relax
\else
  \ifnum\pdfoutput>0
    \pdftextrue
  \fi
\fi

\ifpdftex
\pdfcompresslevel=9
\PassOptionsToPackage{hyperindex,plainpages=false,linktocpage,colorlinks=true,linkcolor=black,citecolor=black, urlcolor=black}{hyperref}
\PassOptionsToPackage{pdftex}{graphicx}
\else
\PassOptionsToPackage{hypertex}{hyperref}
\PassOptionsToPackage{dvips}{graphicx}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	\newtextcommand														%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\newtextcommand}[2]{\newcommand{#1}{\begingroup#2\endgroup\xspace}}
\newcommand{\renewtextcommand}[2]{\renewcommand{#1}{\begingroup#2\endgroup\xspace}}
\newcommand{\providetextcommand}[2]{\providecommand{#1}{\begingroup#2\endgroup\xspace}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	SEPARATOR PAGE														%%
%%		Crea una pagina vuota con un testo centrato sia orizzontalmente	%%
%%		sia verticalmente. Questa pagina non viene contata nè numerata.	%%
%%		Queste pagine sono richieste nel formato di tesi prima di 		%%
%%		sezioni come gli appendici e la bibliografia.					%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\separatorpage#1{
  \newpage
  \thispagestyle{empty}
  \addtocounter{page}{-1}
  \null
  \vfil\vfil
  \begin{center}
    {\bface #1}
  \end{center}
  \vfil\vfil
  \newpage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	COPYRIGHT PAGE														%%
%%		Deve iniziare una nuova pagina senza il numero e immettere		%%
%%		il testo centrato e allineato in basso.							%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\BibTeX{{\rm B\kern-.05em{\sc i\kern-.025em b}\kern-.08em
    T\kern-.1667em\lower.7ex\hbox{E}\kern-.125emX}}

\def\copyrightpage{
  \newpage
  \addtocounter{page}{-1}
  \chapter*{}            % Required for \vfill to work
  \begin{center}
    \vfill
    \ifenglish
       Written with
    \else
       Scritta con
    \fi
   \LaTeXe{} 
   \ifenglish
      and
   \else
      e
   \fi
   \BibTeX \\
   \vspace{10.0pt}
    \ifenglish
       Printed on
    \else
       Stampata il
    \fi
   \@date\\
  \thispagestyle{empty}    % No page number
  \end{center}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	GLOSSARY															%%
%%		Deve stampare la tabella dei contenuti del glossario e iniziare	%%
%%		una nuova pagina con GLOSSARY centrato e due pollici dal top.	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\glossary{\separatorpage{DISCARD THIS PAGE}
  \chapter*{GLOSSARY}
  \addcontentsline{toc}{chapter}{GLOSSARY}}
\def\endglossary{\par\newpage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	NOMENCLATURE														%%
%%		Deve stampare la tabella dei contenuti della nomenclatura e 	%%
%%		iniziare una nuova pagina con NOMENCLATURE centrato e due 		%%
%%		pollici dalla cima.												%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\nomenclature{\separatorpage{DISCARD THIS PAGE}
  \chapter*{NOMENCLATURE}
  \addcontentsline{toc}{chapter}{NOMENCLATURE}}
\def\endnomenclature{\par\newpage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	LIST OF SYMBOLS														%%
%%		Deve stampare la tabella dei contenuti della lista di simboli	%%
%%		e iniziare una nuova pagina con LIST OF SYMBOLS centrato e due	%%
%%		pollici dalla cima.												%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\listofsymbols{\separatorpage{DISCARD THIS PAGE}
  \chapter*{LIST OF SYMBOLS}
  \addcontentsline{toc}{chapter}{LIST OF SYMBOLS}}
\def\endlistofsymbols{\par\newpage}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Iniziamo il trattamento delle opzioni. Definiamo i condizionali:	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifdraft\draftfalse
\newif\ifenglish\englishfalse
\newif\iflof\loffalse
\newif\iflot\lotfalse
\newif\iflol\lolfalse
\newif\iffullbib\fullbibtrue
\newif\ifshort\shortfalse
\newif\ifbibtexused\bibtexusedfalse
\newif\iftwoside\twosidefalse
\newif\ifletterp\letterpfalse

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Elaboriamo le opzioni mappandole sui condizionali appena definiti:	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\DeclareOption{draft}{\drafttrue\fullbibfalse\shorttrue}
\DeclareOption{final}{\draftfalse\fullbibtrue\shortfalse}
\DeclareOption{english}{\englishtrue}
\DeclareOption{italian}{\englishfalse}
\DeclareOption{listoffigures}{\loftrue}
\DeclareOption{listoftables}{\lottrue}
\DeclareOption{listoflistings}{\loltrue}
\DeclareOption{fullbib}{\fullbibtrue}
\DeclareOption{nofullbib}{\fullbibfalse}
\DeclareOption{bibtex}{\bibtexusedtrue}
\DeclareOption{nobibtex}{\bibtexusedfalse}
\DeclareOption{titlepage}{\shortfalse}
\DeclareOption{notitlepage}{\shorttrue}
\DeclareOption{twoside}{\twosidetrue}
\DeclareOption{letterpaper}{\letterptrue}
\DeclareOption{a4paper}{\letterpfalse}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Avvertiamo quando un'opzione viene ignorata							%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\DeclareOption{legalpaper}{\PackageWarning{tesi}%
{Option '\CurrentOption' ignored.  Must use 'a4paper'.}}
\DeclareOption{executivepaper}{\PackageWarning{tesi}%
{Option '\CurrentOption' ignored.  Must use 'a4paper'.}}
%\DeclareOption{letterpaper}{\PackageWarning{tesi}%
%{Option '\CurrentOption' ignored.  Must use 'a4paper'.}}
\DeclareOption{a5paper}{\PackageWarning{tesi}%
{Option '\CurrentOption' ignored.  Must use 'a4paper'.}}
\DeclareOption{b5paper}{\PackageWarning{tesi}%
{Option '\CurrentOption' ignored.  Must use 'a4paper'.}}
\DeclareOption{twocolumn}{\PackageWarning{tesi}%
{Option '\CurrentOption' ignored.  Must use 'onecolumn'.}}
\DeclareOption{landscape}{\PackageWarning{tesi}%
{Option '\CurrentOption' ignored.  Must use 'portrait'.}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Passiamo le altre opzioni a book.cls								%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\PassOptionsToClass{onecolumn}{book}
\PassOptionsToClass{twoside}{book}
\ifletterp
\PassOptionsToClass{letterpaper}{book}
\else
\PassOptionsToClass{a4paper}{book}
\fi
\PassOptionsToClass{12pt}{book}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{book}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Questo termina l'elaborazione delle opzioni.						%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ProcessOptions\relax

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Carica la classe book e gli altri pacchetti che servono.			%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\LoadClass{book}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Definisce la profondità delle sezioni:								%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{2}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Carica Babel e le traduzioni aggiuntive. Alcune stringhe non sono 	%%
%%	tradotte perchè la pagina del titolo deve rimanere in italiano.		%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newtextcommand{\tesi@draftoftoday}{Bozza del \today}
\newtextcommand{\tesi@ackname}{Ringraziamenti}
\newtextcommand{\tesi@summary}{Sommario}
\newtextcommand{\tesi@yearname}{Anno Accademico}
\newtextcommand{\tesi@advname}{Relatore}
\newtextcommand{\tesi@coadvname}{Correlatore}
\newtextcommand{\tesi@matrname}{Matr.}
\newtextcommand{\tesi@of}{Tesi di laurea di}

\ifenglish
\RequirePackage[greek,italian,english]{babel}
\renewtextcommand{\tesi@draftoftoday}{Draft of \today}
\renewtextcommand{\tesi@ackname}{Acknowledgements}
\newtextcommand{\tesi@summary}{Summary}
\renewtextcommand{\tesi@yearname}{Academic year}
\renewtextcommand{\tesi@advname}{Advisor}
\renewtextcommand{\tesi@coadvname}{Co-advisor}
\renewtextcommand{\tesi@matrname}{Matr.}
\renewtextcommand{\tesi@of}{Master thesis of}
\selectlanguage{english}
\main@language{english}
\else
\RequirePackage[greek,english,italian]{babel}
\selectlanguage{italian}
\main@language{italian}
\frenchspacing
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Questi si usano sempre												%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage[latin1]{inputenc}	% Per leggere gli accenti
\RequirePackage[T1]{fontenc}        % Per sillabare le parole accentate
\RequirePackage{aeguill}            % Mappa i font 8-bit su quelli 7-bit
									%  (che escono bene in PDF)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Questi sono inclusi per comodità dell'utente						%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{amsmath}           	% Per le formule matematiche
\RequirePackage{makeidx}            % Per gli indici
\RequirePackage{calc}
\RequirePackage{amssymb}
\RequirePackage{listings}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Questi sono inclusi per la grafica (come il logo del frontespizio)	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{graphicx}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Questi invece servono per il modello								%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{xspace}             % Per \newtextcommand
\RequirePackage{verbatim}           % Per l'ambiente comment
\RequirePackage{natbib}             % Per la bibliografia
\RequirePackage{fancyhdr}           % Per le intestazioni
\RequirePackage{setspace}           % Per spaziare il testo
\RequirePackage[breaklinks=true
			   ,draft=false
			   ,bookmarks
			   ,bookmarksnumbered
			   ,pagebackref
			   ,pdfpagemode=UseOutlines
			   ,pdfpagelabels
			   ,pdfpagelayout={SinglePage}]
				{hyperref}		% Per i link
\RequirePackage{subfigure}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Configuriamo graphicx												%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifpdftex
\DeclareGraphicsExtensions{.mps,.pdf,.png}
\else
\DeclareGraphicsExtensions{.ps,.eps,.mps}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Configuriamo graphicx												%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand\lstlistlistingname{Elenco dei codici}
\renewcommand\lstlistingname{Codice}
\lstset{captionpos=b
	   ,aboveskip=15pt
	   ,breaklines
	   ,breakatwhitespace}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Configuriamo natbib. Se si usa BibTeX citiamo il nome completo		%%
%%	dell'autore, altrimenti usiamo le citazioni numeriche.				%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifbibtexused
%  \bibpunct[, ]{(}{)}{;}{a}{,}{,}
  \bibpunct[, ]{[}{]}{;}{a}{,}{,}
  \bibliographystyle{amsalpha}
%\bibliographystyle{unsrt}
\else
  \bibpunct[, ]{[}{]}{,}{n}{,}{,}
  \bibliographystyle{plainnat}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Eliminiamo dagli URL gli spazi che BibTeX inserisce per facilitare	%%
%%	la sillabazione.													%%
%%	Dobbiamo espandere l'argomento che contiene l'URL.  Inoltre ci 		%%
%%	servono due marker consecutivi per la fine dell'URL, perche' nella	%%
%%	macro \tesi@linkdoit #2 e' un argomento delimitato e puo' esser 	%%
%%	vuoto, ma #1 no (altrimenti alla fine dell'URL #1 diventa \@endurl	%%
%%	creando un casino di proporzioni inenarrabili).						%%
%%	L'URL viene inserito in un argomento delimitato subito dopo il nome %%
%%	della macro \tesi@linkdoit, e spostato un carattere alla volta 	%%
%%	nell'argomento #3. Durante il procedimento Tex si mangia 			%%
%%	automaticamente gli spazi appena diventano il primo carattere, 		%%
%%	perche' vengono subito dopo il nome di una macro!					%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%\let\tesi@linkurl\hyper@linkurl
%\def\hyper@linkurl#1#2{
%	\edef\@tempa{#2}
%	\expandafter\tesi@linkdoit\@tempa\@endurl\@@endurl{#1}{}}
%\def\tesi@linkdoit#1#2\@@endurl#3#4{
%	\def\@tempa{#1}\def\@tempb{\@endurl}
%	\ifx\@tempa\@tempb \tesi@linkurl{#3}{#4}
%	\else\tesi@linkdoit #2\@@endurl{#3}{#4#1}\fi}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Definiamo il layout della pagina									%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\RequirePackage{geometry}
\ifletterp
\iftwoside
\geometry{letterpaper, top=0pt+2.5cm, left=-0.7cm+3.2cm, bottom=0pt+2.5cm, right=0.7cm+3.2cm,twoside, twosideshift=0.7cm+0.7cm, headsep=25pt, footskip=42pt}
\else
\geometry{letterpaper, top=0pt+2.5cm, left=-0.7cm+3.2cm, bottom=0pt+2.5cm, right=0.7cm+3.2cm, twosideshift=0.7cm, headsep=25pt, footskip=42pt}
\fi
\else
\iftwoside
\geometry{a4paper, pdftex, left=0.18\paperwidth, width=0.7\paperwidth, top=0.15\paperheight, height=0.7\paperheight, headsep=25pt, footskip=42pt, twoside,headheight=15pt}
\else
\geometry{a4paper, pdftex, left=0.15\paperwidth, width=0.7\paperwidth, top=0.15\paperheight, height=0.7\paperheight, headsep=25pt, footskip=42pt, headheight=15pt, hoffset=0.04\paperwidth}
%\geometry{a4paper, pdftex, left=0.15\paperwidth, width=0.7\paperwidth, top=0.1\paperheight, height=0.8\paperheight, twosideshift=0pt, headsep=25pt, footskip=42pt, headheight=15pt}
\fi
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	\fussy definisce un emergencystretch troppo basso; d'altro canto	%%
%%	la spaziatura di \sloppy fa veramente schifo. Definiamo una via		%%
%%	di mezzo															%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\fussy
\ifdraft\overfullrule=5pt\else\overfullrule=0pt\fi
\tolerance=300
\emergencystretch 2em

\widowpenalty=10000
\clubpenalty=10000

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Per comodità, definiamo due comandi che ridefiniscono le			%%
%%	intestazioni utilizzando fancyhdr.									%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\tesi@defheadertwoside}{
  % Disegna il fondo della pagina; se bozza, mette "Bozza del..."
  % e una riga orizzontale che separa dal testo
  \renewcommand{\chaptermark}[1]{%
    \markboth{\chaptername~\thechapter.\hspace{12pt}##1}{\chaptername~\thechapter.\hspace{12pt}##1}}
  \renewcommand{\sectionmark}[1]{%
    \markright{\thesection.~##1}}

    \fancyhf[hel]{\leftmark\vspace{0.1pt}}
    \fancyhf[hor]{\rightmark\vspace{0.1pt}}
    \renewcommand{\headrulewidth}{0.4pt}
}

\newcommand{\tesi@deffootertwoside}{
  % Disegna il fondo della pagina; se bozza, mette "Bozza del..."
  % e una riga orizzontale che separa dal testo
  \ifdraft
  \else
    \fancyhf[fle,fro]{\thepage}
    \renewcommand{\footruleskip}{6pt}
    \renewcommand{\footrulewidth}{0pt}
  \fi
}

\newcommand{\tesi@deffooterdraft}{
  % Disegna il fondo della pagina; se bozza, mette "Bozza del..."
  % e una riga orizzontale che separa dal testo
  \ifdraft
   \iftwoside
     \fancyhf[fer,fol]{\vspace{0.1pt}\tesi@draftoftoday}
     \fancyhf[fle,fro]{\vspace{0.1pt}\thepage}
     \renewcommand{\footruleskip}{6pt}
     \renewcommand{\footrulewidth}{0.4pt}
   \else
     \fancyhf[fc]{\vspace{0.1pt}\tesi@draftoftoday}
     \renewcommand{\footruleskip}{6pt}
     \renewcommand{\footrulewidth}{0.4pt}
   \fi
  \else
  \fi
}


\newcommand{\tesi@defheaderoneside}{
  % Disegna il fondo della pagina; se bozza, mette "Bozza del..."
  % e una riga orizzontale che separa dal testo
  \renewcommand{\chaptermark}[1]{%
    \markboth{\chaptername~\thechapter.\hspace{12pt}##1}{\chaptername~\thechapter.\hspace{12pt}##1}}
  \renewcommand{\sectionmark}[1]{%
    \markright{\thesection.~##1}}

    \fancyhf[hel]{\rightmark\vspace{0.1pt}}
    \fancyhf[hol]{\rightmark\vspace{0.1pt}}
    \fancyhf[hr]{\vspace{0.1pt}}
    \renewcommand{\headrulewidth}{0.4pt}
}

\newcommand{\tesi@deffooteroneside}{
  % Disegna il fondo della pagina; se bozza, mette "Bozza del..."
  % e una riga orizzontale che separa dal testo
  \ifdraft
  \else
    \fancyhf[fr]{\thepage}
    \renewcommand{\footruleskip}{6pt}
    \renewcommand{\footrulewidth}{0pt}
  \fi
}

\newcommand{\tesi@deffooternolinetwoside}{
  % Disegna il fondo della pagina; se bozza, mette "Bozza del..."
  % e una riga orizzontale che separa dal testo
  \ifdraft
  \else
    \fancyhf[fle,fro]{\thepage}
    \renewcommand{\footruleskip}{6pt}
    \renewcommand{\footrulewidth}{0pt}
  \fi
}

\newcommand{\tesi@defpagestyle}{
  % Per le pagine "plain", disabilita il numero di pagina al centro
  \fancypagestyle{plain}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \iftwoside
  \tesi@deffooternolinetwoside
  \tesi@deffooterdraft
  \else
  \tesi@deffooteroneside
  \tesi@deffooterdraft
  \fi}

  \fancypagestyle{fancyplain}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}}

  % Rende minuscolo il titolo del capitolo e della sezione
  \renewcommand{\chaptermark}[1]{%
    \markboth{\chaptername~\thechapter.\ ##1}{\chaptername~\thechapter.\ ##1}}
  \renewcommand{\sectionmark}[1]{%
    \markright{\thesection.\ ##1}}

  % Disegna le intestazioni di pagina
  \pagestyle{fancy}
  \fancyhf{}
  \iftwoside
  \tesi@defheadertwoside
  \tesi@deffootertwoside
  \tesi@deffooterdraft
  \else
  \tesi@defheaderoneside
  \tesi@deffooteroneside
  \tesi@deffooterdraft
  \fi
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Ridefiniamo anche alcuni comandi per la struttura del documento	per	%%
%%	renderla più standard.												%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\let\tesi@subsubsection\subsubsection
   \renewcommand{\subsubsection}[1]{
   \tesi@subsubsection{#1}
   \addcontentsline{toc}{paragraph}{#1}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Ridefiniamo \maketitle per cambiare il formato della pagina titolo	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\renewcommand{\maketitle}{
  \begin{titlepage}
%    \null \vskip 40\p@
    \begin{center}
      {\large \tesi@universita\par} \vskip 1cm
      \linespread{1} \LARGE \bf \@title \par
      \ifdraft\vskip 2cm\large \tesi@draftoftoday\par\fi
    \end{center}
    \vfill

    {\large \tesi@relatore\par}
    {\large \tesi@correlatore\par}
    \vfill

  \begin{flushright}
	\begin{tabular}{r}
    {\large \tesi@of\par}\\[1ex]
    {\large \@author\par}\\[1ex]
    {\large \tesi@matricola\par}\\
	\end{tabular}
   \end{flushright}
    \vfill

    \begin{center}
      {\large \tesi@anno\par}% \vskip 1.5em
    \end{center}
  \end{titlepage}
  \global\let\maketitle\relax
  \global\let\title\relax
  \global\let\author\relax
  \global\let\advisor\relax
  \global\let\date\relax
  \global\let\and\relax
  \pagestyle{plain}
  \pagenumbering{roman}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	lasciamo bianca la pagina eventualmente generata da					%%
%%	\cleardoublepage													%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\def\cleardoublepage{\clearpage\if@twoside \ifodd\c@page\else
    \thispagestyle{empty}\null\newpage\fi\fi}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Semplifica l'utilizzo di \frontmatter, \mainmatter, \backmatter.	%%
%%	\frontmatter genera la pagina con i titoli.							%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\let\tesi@frontmatter\frontmatter
\renewcommand{\frontmatter}{
  \ifpdftex
    \ifenglish
      \pdfbookmark[0]{Title Page}{titlepage}
    \else
      \pdfbookmark[0]{Frontespizio}{titlepage}
    \fi     
  \fi
  \tesi@frontmatter
  \maketitle
  \advance\c@page by 1

%  \pagestyle{empty}
  \tesi@defpagestyle
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Tra \frontmatter e \mainmatter vanno i ringraziamenti. \mainmatter	%%
%%	genera gli indici.													%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\let\tesi@mainmatter\mainmatter
\renewcommand{\mainmatter}{
  \cleardoublepage
  %
  % Dopo l'indice, ridefinisce \chapter* in modo che introduzione,
  % conclusione e bibliografia abbiano una voce nell'indice.
  \gdef\@schapter##1{\phantomsection
    % Usa \expandafter per espandere \bibname, ecc.
    \if@mainmatter
    \toks@\expandafter{##1}
    \addcontentsline{toc}{chapter}{\the\toks@}
    \addtocontents{lot}{\protect\addvspace{10\p@}}
    \addtocontents{lof}{\protect\addvspace{10\p@}}
    \fi
    \markboth{##1}{##1}
    \@makeschapterhead{##1}
    \@afterheading}
  \tesi@defpagestyle
  \onehalfspacing
  %\doublespacing
  %\singlespacing

  % Generiamo a mano il capitolo altrimenti CONTENTS esce in
  % maiuscolo nell'intestazione, cosa che non ci piace.
  \ifpdftex
     \pdfbookmark[0]{\contentsname}{contentsname}
   \fi
  \chapter*{\contentsname}
  \setcounter{tocdepth}{3} % per mostrare le sub-subsection
  \@starttoc{toc}
  \ifshort
  \else
    \iflot\listoftables\else\fi
    \iflof\listoffigures\else\fi
    \iflol\lstlistoflistings\else\fi
  \fi
  \tesi@mainmatter
  \tesi@defpagestyle
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	\backmatter risistema la spaziatura e genera nell'indice			%%
%%	l'intestazione per la bibliografia. Dopo \backmatter va				%%
%%	\bibliography o \begin{thebibliography}.							%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\let\tesi@backmatter\backmatter
\renewcommand{\backmatter}{
  \tesi@backmatter
  \tesi@defpagestyle
  \iffullbib\nocite{*}\else\fi
  \singlespacing
}

\let\tesi@bibliography\bibliography
\renewcommand{\bibliography}[1]{
  \renewcommand{\bibname}{\refname}
  \iftwoside
    \fancyhf[hel]{\nouppercase{\leftmark}\vspace{0.1pt}}
    \fancyhf[hor]{\nouppercase{\rightmark}\vspace{0.1pt}}
  \else
    \fancyhf[hel]{\nouppercase{\rightmark}\vspace{0.1pt}}
    \fancyhf[hol]{\nouppercase{\rightmark}\vspace{0.1pt}}
  \fi
  \tesi@bibliography{#1}
  \addcontentsline{toc}{chapter}{\refname}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Infine bisogna definire gli ambienti con le varie parti dell'intro	%%
%%	Iniziamo dall'abstract che ha un layout simile a una pagina titolo	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{abstract}{
  \begin{titlepage}
    \pagestyle{empty}
    \begin{center}
    \tesi@anno \\
    \tesi@universita \\
    {\Large \bf \@title}\par\bigskip
    \@author \\
    {\bf \tesi@abstractname}\par\bigskip
    \end{center}
}{
  \end{titlepage}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	La dedica è una pagina vuota con del testo rientrato a 1/3			%%
%%	dell'altezza														%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{dedica}{
  \thispagestyle{empty}
  \cleardoublepage
  \vspace{15cm}
  \begin{flushright}
  	\itshape{\item}
}
{
  \thispagestyle{empty}
  \cleardoublepage
  \end{flushright}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	I ringraziamenti hanno lo stesso layout di un capitolo. Tuttavia	%%
%%	se sono presenti più ringraziamenti, invece di generare una nuova	%%
%%	intestazione divide in due la pagina con una riga orizzontale.		%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifprimoringraz\primoringraztrue
\newenvironment{ringraziamenti}{
  \ifprimoringraz
    \chapter{\tesi@ackname}~\par
  \else%
    \hrule\bigskip\ignorespaces
  \fi%
}{\vfill\global\primoringrazfalse\ignorespaces}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Il sommario ha lo stesso layout di un capitolo.						%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newif\ifprimosommar\primosommartrue
\newenvironment{sommario}{
  \ifprimosommar
    \chapter{\tesi@summary}~\par
  \else%
    \hrule\bigskip\ignorespaces
  \fi%
}{\vfill\global\primosommarfalse\ignorespaces}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Tutti questi sono omessi se l'opzione "notitlepage" è specificata.	%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\ifshort
\renewenvironment{abstract}{\comment}{\endcomment}
\renewenvironment{dedica}{\comment}{\endcomment}
\renewenvironment{ringraziamenti}{\comment}{\endcomment}
\fi

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Ora bisogna definire i comandi per le parti variabili della pagina	%%
%%	titolo, dato che rispetto alla classe book ne abbiamo alcuni		%%
%%	aggiuntivi.															%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand\anno[1]{\gdef\tesi@anno{\tesi@yearname~#1}}
\newcommand\matricola[1]{\gdef\tesi@matricola{\tesi@matrname~#1}}
\newcommand\relatore[1]{\gdef\tesi@relatore{\tesi@advname:~#1}}
\newcommand\correlatore[1]{\gdef\tesi@correlatore{\tesi@coadvname:~#1}}
\newcommand\universita[4][\empty]{%
  % Mette la prima parte in \toks@
  \toks@{%
    {\sc #2} \par\vskip 0.5em
    {\sc\it #3} \par\vskip 0.5em
    {#4}
  }

  % Se serve aggiunge la seconda parte in \toks@
  \edef\@tempa{#1}%
  \ifx\@tempa\empty\else
    \toks@\expandafter{\the\toks@
      \par\vskip 1.5em
      \centering \resizebox{4cm}{!}{\includegraphics[angle=-90]{#1}}
    }
  \fi

  % Mette il tutto in \tesi@universita
  \expandafter\gdef\expandafter\tesi@universita\expandafter{%
    \the\toks@%
    \par\vfill%
  }
}

\def\tesi@universita{\@latex@warning@no@line{Manca \noexpand\universita}}
\def\tesi@anno{\@latex@warning@no@line{Manca \noexpand\anno}}
\def\tesi@relatore{\@latex@warning@no@line{Manca \noexpand\relatore}}
\def\tesi@matricola{~}
\def\tesi@correlatore{~}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Infine altri comandi e ambienti personalizzati.						%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcommand{\draftnote}[1]{\ifdraft\emph{[#1]}\else\fi}
\newcommand{\footnoteref}[2][]{\footnote{\seename\xspace#1~\ref{#2}.}}
\newcommand{\strong}[1]{\textbf{#1}}

\newcommand{\code}[1]{%
  \texorpdfstring{%
     \foreignlanguage{english}{\texttt{\hyphenchar\font=`-%
       \begingroup\protect\frenchspacing#1\endgroup}}}{%
     #1}}

\newenvironment{ignore}{\comment}{\endcomment}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	Rispetto al normale verbatim, questo ha un rientro sulla sinistra,	%%
%%	ma inoltre le linee vuote hanno un'interlinepenalty nulla che 		%%
%%	annulla il comando \samepage della prima riga.						%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newenvironment{example}%
  {\list{}{\leftmargin 2.5em \setstretch{1}\samepage}
   \item\relax\overfullrule=0pt%
   %
   % Il package verbatim permette di fare cose particolari con ogni linea
   % molto semplicemente (o quasi) ridefinendo la macro \verbatim@processline,
   % quella che di fatto emette il paragrafo.  Il giochetto con \expandafter
   % imposta \this@line al contenuto di \the\verbatim@line, espandendo
   % quest'ultimo.  In pratica lascia in sospeso tutto tra \def (incluso)
   % e \the\verbatim@line (escluso), espande quest'ultimo, e riprende da \def.
   % La linea successiva controlla se \this@line e' vuoto e se si' imposta a
   % zero la interlinepenalty.  Tutto viene fatto in un gruppo per ripristinare
   % il valore precedente della interlinepenalty.
   \let\old@processline\verbatim@processline
   \def\verbatim@processline{
     \begingroup%
       \expandafter\def\expandafter\this@line\expandafter{\the\verbatim@line}%
       \ifx\this@line\empty\interlinepenalty\z@\fi%
       \old@processline%
     \endgroup}%
   \verbatim}%
  {\endverbatim
   \endlist
   \par}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	L'ambiente listing usa example, ma aggiunge un contatore di linea	%%
%%	sulla sinistra.														%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\newcounter{tesi@listingline}
\newenvironment{listing}
  {\setcounter{tesi@listingline}{0}
   \def\verbatim@processline{
     \stepcounter{tesi@listingline}
     \begingroup
       \leavevmode
       \llap{\hss\footnotesize\rmfamily\arabic{tesi@listingline}~~}
       \the\verbatim@line\par
     \endgroup}
   \example}
  {\endexample}


\newenvironment{firstquote}[2]
  {
   \def\chquoteauthor{#1}
   \def\chquotesource{#2}
   \newpage
   \thispagestyle{empty}
   \null
   \vfill

   \linespread{1.3}
   \list{}{\leftmargin 15em\rightmargin 2em\raggedright \itshape}
 \item
  }
  { \vspace{1em}
    \item \hspace{1.5em} \normalfont \chquoteauthor\ifx\chquoteauthor\empty\else{, }\fi \itshape \chquotesource
    \endlist
    \linespread{1}
    \vfill
    \vfill
  \newpage
  }


\newenvironment{initialquote}%
  {\list{}{%
    \leftmargin 15em\rightmargin 3em\raggedright \setstretch{1}\itshape}
   \item}
  {\endlist}


\newenvironment{chapterquote}[2]
  {
   \def\chquoteauthor{#1}
   \def\chquotesource{#2}
    \vspace{0.5cm}
    \list{}{
    \leftmargin 12em\rightmargin 2em\raggedright \setstretch{1}\itshape}
   \item}
  {\item \hspace{1.5em} \normalfont \chquoteauthor\ifx\chquoteauthor\empty\else\ifx\chquotesource\empty\else{, }\fi\fi \itshape \chquotesource
    \endlist
    \vspace{1cm}
  }


\newcommand{\cha}[2]{\chapter{#1}
     {\null\vspace{20pt} {\large %
       \begin{flushright}%
	 #2%
       \end{flushright}}%
       \vspace{20pt}\null}%
     \noindent%
     %\clearpage%
}

%% \newcommand\chapter{\if@openright\cleardoublepage\else\clearpage\fi
%%                     \thispagestyle{plain}%
%%                     \global\@topnum\z@
%%                     \@afterindentfalse
%%                     \secdef\@chapter\@schapter}
%% \def\@chapter[#1]{[#2]}#3{\ifnum \c@secnumdepth >\m@ne
%%                        \if@mainmatter
%%                          \refstepcounter{chapter}%
%%                          \typeout{\@chapapp\space\thechapter.}%
%%                          \addcontentsline{toc}{chapter}%
%%                                    {\protect\numberline{\thechapter}#1}%
%%                        \else
%%                          \addcontentsline{toc}{chapter}{#1}%
%%                        \fi
%%                     \else
%%                       \addcontentsline{toc}{chapter}{#1}%
%%                     \fi
%%                     \chaptermark{#1}%
%%                     \addtocontents{lof}{\protect\addvspace{10\p@}}%
%%                     \addtocontents{lot}{\protect\addvspace{10\p@}}%
%%                     \if@twocolumn
%%                       \@topnewpage[\@makechapterhead{#3} \@printquote{#2}]%
%%                     \else
%%                       \@makechapterhead{#3}%
%% 		      \@printquote{#2}%
%%                       \@afterheading
%%                     \fi}

%% \def\@printquote#1{%
%%      {\null\vfil {\large %
%%        \begin{flushright}%
%% 	 Livio #1
%% %% 	 \emph{Sometimes, we have to be able to come back on our%
%% %% 	   step}\\\vspace{12pt} \emph{if we want to be able to take a jump%
%% %% 	   forward}\\\vspace{12pt} \vspace{2cm}Marco Somalvico.%
%%      \end{flushright}}%
%%      \vfil\null}%
%%      \clearpage%
%% }

%%  \def\@makechapterhead#1{%
%%    \vspace*{50\p@}%
%%    {\parindent \z@ \raggedright \normalfont
%%      \ifnum \c@secnumdepth >\m@ne
%%        \if@mainmatter
%%          \huge\bfseries \@chapapp\space \thechapter
%%          \par\nobreak
%%          \vskip 20\p@
%%        \fi
%%      \fi
%%      \interlinepenalty\@M
%%      \Huge \bfseries #1\par\nobreak
%%      \vskip 40\p@
%%    }}


%% \def\@schapter#1{\if@twocolumn
%%                    \@topnewpage[\@makeschapterhead{#1}]%
%%                  \else
%%                    \@makeschapterhead{#1}%
%%                    \@afterheading
%%                  \fi}
%% \def\@makeschapterhead#1{%
%%   \vspace*{50\p@}%
%%   {\parindent \z@ \raggedright
%%     \normalfont
%%     \interlinepenalty\@M
%%     \Huge \bfseries  #1\par\nobreak
%%     \vskip 40\p@
%%   }}
