;; A Gentle introduction to CEDET
;;
;; This article doesn't pretend to be detailed description on how to setup
;; Emacs to be complete development environment. I just tried to provide a
;; small description on "How to setup CEDET to work with C, C++ & Java",
;; although most of this description will be also applicable for other languages,
;; supported by CEDET
;;
;;
;; What is CEDET?
;; The CEDET package is a collection of libraries, that implement different commands,
;; but all of them have common goal — provide functionality for work with
;; source code written in different programming languages
;; (please, take into account that not all of these packages are included into CEDET
;; bundled with GNU Emacs):
;;
;; Semantic is a base for construction of syntactic analyzers for different programming languages.
;; It provides common representation of information extracted from code.
;; Using this information, CEDET & other packages, such as JDEE and ECB, can implement functionality,
;; required for modern development environment — name completion, code navigation, etc.;
;;
;; SemanticDB is included into Semantic, and implements different storage modules,
;; that store information, needed for names completion, source code navigation, etc.
;; Syntactic information may be saved between Emacs sessions,
;; so this reduces need for re-parsing of source code that wasn't modified since last parse;
;;
;; Senator implements navigation in source code using information extracted by Semantic;
;;
;; Srecode is a package for source code generation using syntactic information
;; (including information, extracted by Semantic);
;;
;; EDE implements a set of extensions to work with projects —
;; user can control list of the targets to build, build the project, etc.
;; Besides this, using the notion of the project,
;; you can have more precise control over Semantic's operations — name completions, navigation, etc.;
;;
;; Speedbar is used to display information about current buffer using different sources of information —
;; Semantic, some specialized information providers (for texinfo & HTML, for example).
;;
;; Eieio is a library, that implements CLOS-like (Common Lisp Object System)
;; infrastructure for Emacs Lisp;
;;
;; Cogre is a library for generation of UML-like diagrams in Emacs buffer,
;; with basic integration with Semantic.
;;
;;
;; Installation of standalone CEDET's version
;;
;; git clone http://git.code.sf.net/p/cedet/git cedet 
;; make clean-all && make
;;
;; Customization
;; 
;; If you're using standalone CEDET's version, then you need to load it with following command:
;; 
;; (load-file "~/emacs/cedet-bzr/cedet-devel-load.el")
;;
;; But if you're using CEDET bundled with GNU Emacs, then everything will be already loaded on start.
;;
;;
;;
;; Semantic's customization
;; All standalone versions until release 1.1 (including) had activation method
;; that was different from method for CEDET bundled into GNU Emacs.
;; In new versions activation of package is performed by adding of symbols for
;; selected sub-modes into special list, and then activating semantic-mode.
;; While in the "old" versions, functionality was activated by calling one of the functions,
;; each of them activated some specific set of features.
;; So in the "new" version, it's enough to do following:
;;
;;
;; enables global support for Semanticdb;
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode)
;;
;;
;; enables automatic bookmarking of tags that you edited,
;; so you can return to them later with the semantic-mrub-switch-tags command;
(add-to-list 'semantic-default-submodes 'global-semantic-mru-bookmark-mode)
;;
;;
;; activates CEDET's context menu that is bound to right mouse button;
(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode)
;;
;;
;; activates highlighting of first line for current tag (function, class, etc.);
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-func-mode)
;;
;;
;; activates mode when name of current tag will be shown in top line of buffer;
(add-to-list 'semantic-default-submodes 'global-semantic-stickyfunc-mode)
;;
;;
;; activates use of separate styles for tags decoration (depending on tag's class).
;; These styles are defined in the semantic-decoration-styles list;
(add-to-list 'semantic-default-submodes 'global-semantic-decoration-mode)
;;
;;
;; activates highlighting of local names that are the same as name of tag under cursor;
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
;;
;;
;; activates automatic parsing of source code in the idle time;
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode)
;;
;;
;; activates displaying of possible name completions in the idle time.
;; Requires that global-semantic-idle-scheduler-mode was enabled;
(add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode)
;;
;;
;; activates displaying of information about current tag in the idle time.
;; Requires that global-semantic-idle-scheduler-mode was enabled.
(add-to-list 'semantic-default-submodes 'global-semantic-idle-summary-mode)
;;
;;
;; Following sub-modes are usually useful when you develop and/or debug CEDET:
;;
;;
;; shows which elements weren't processed by current parser's rules;
(add-to-list 'semantic-default-submodes 'global-semantic-show-unmatched-syntax-mode)
;;
;;
;; shows current parser state in the modeline;
(add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)
;;
;;
;; shows changes in the text that weren't processed by incremental parser yet.
(add-to-list 'semantic-default-submodes 'global-semantic-highlight-edits-mode)
;;
;;
;; activates code folding
(add-to-list 'semantic-default-submodes 'global-semantic-tag-folding-mode)
;;
;;
(semantic-mode 1)
;;
;;
;; This approach allows to make Semantic's customization more flexible,
;; as user can switch on only necessary features.
;; You can also use functions with the same names to enable/disable corresponding
;; sub-modes for current Emacs session.
;; And you can also enable/disable these modes on the per-buffer basis (usually this is done from hook):
;; names of corresponding variables you can find in description of global-semantic-* functions.
;; 
;; To enable more advanced functionality for name completion, etc.,
;; you can load the semantic/ia with following command:
(require 'semantic/ia)
;;
;;
;; After loading of this package, you'll get access to commands, described below.
;;
;;
;; System header files
;; To normal work with system-wide libraries, Semantic should has access to system include files,
;; that contain information about functions & data types, implemented by these libraries.
;;
;; If you're using GCC for programming in C & C++, then Semantic can automatically find directory,
;; where system include files are stored. Just load semantic/bovine/gcc package with following command:
(require 'semantic/bovine/gcc)
;;
;;
;; You can also explicitly specify additional directories for searching of include files
;; (and these directories also could be different for specific modes).
;; To add some directory to list of system include paths,
;; you can use the semantic-add-system-include command — it accepts two parameters:
;; string with path to include files, and symbol, representing name of major mode,
;; for which this path will be used.
;; For example, to add Boost header files for C++ mode, you need to add following code:
(semantic-add-system-include "~/Downloads/boost_1_74_0/" 'c++-mode)
;;
;;
;; Although I want to say, that customization for Boost support is more complex,
;; and requires to specify where Semantic can find files with constant's definitions, etc.
;;
;;
;; Semantic's work optimization
;; To optimize work with tags, you can use several techniques:
;;
;; limit search by using an EDE project, as described below;
;;
;; explicitly specify a list of root directories for your projects,
;; so Semantic will use limited number of databases with syntactic information;
;;
;; explicitly generate tags databases for often used directories (/usr/include, /usr/local/include,..).
;; You can use commands semanticdb-create-ebrowse-database or semanticdb-create-cscope-database;
;;
;; limit search by customization of the semanticdb-find-default-throttle variable for concrete modes —
;; for example, don't use information from system include files,
;; by removing system symbol from list of objects to search for c-mode:
(setq-mode-local c-mode semanticdb-find-default-throttle
		 '(project unloaded system recursive))
;;
;;
;; Semantic extracts syntactic information when Emacs is idle.
;; You can customize the semantic-idle-scheduler-idle-time variable to specify idle time (in seconds),
;; if you don't want to use default value (1 second).
;;
;;
;; Integration with imenu
;; The Semantic package can be integrated with the imenu package.
;; This lead to creation of a menu with a list of functions, variables, and other tags.
;; To enable this feature you need to add following code into your initialization file:
;;
;; FIXME: for some reason this cedet-gnu-global-version-check cause error
;; if you want to enable support for gnu global
;;(when (cedet-gnu-global-version-check t)  
;;  (semanticdb-enable-gnu-global-databases 'c-mode)  
;;  (semanticdb-enable-gnu-global-databases 'c++-mode))
;;
;;
;; FIXME: for some reason this cedet-gnu-global-version-check cause error
;; enable ctags for some languages:
;; Unix Shell, Perl, Pascal, Tcl, Fortran, Asm
;;(when (cedet-ectag-version-check t)
;;  (semantic-load-enable-primary-exuberent-ctags-support))
;;
;;
;; EDE's customization
;; If you plan to use projects, then you need to enable corresponding mode,
;; implemented by the EDE package:
(global-ede-mode t)
;;
;;
;; There are several types of projects supported by EDE, and I want to describe here only some of them.
;; 
;; Using EDE for C & C++ projects
;; For correct work of Semantic with С & C++ code it's recommended to use the EDE package
;; (it allows to work with projects, etc.). For these languages,
;; EDE package defines special project type: ede-cpp-root-project,
;; that provides additional information to Semantic,
;; and this information will be used to analyze source code of your project.
;;
;; To define a project, you need to add following code:
;; (ede-cpp-root-project "Test"
;;                      :name "Test Project"
;;                      :file "~/work/project/CMakeLists.txt"
;;                      :include-path '("/" "/Common"  "/Interfaces" "/Libs" )
;;                      :system-include-path '("~/exp/include")
;;                      :spp-table '(("isUnix" . "")  ("BOOST_TEST_DYN_LINK" . "")))
;;
;;
(load-file ".emacs-projects.el")
;;
;; For the :file parameter you can use any file at root directory of your project.
;; This file isn't parsed — it's used only as an anchor to search all other files in project.
;;
;; To search include files, Semantic uses directories from two lists,
;; that could be specified for project. The :system-include-path parameter is used
;; to specify list of full paths where lookup for "system" include files will be performed.
;; Another parameter — :include-path specifies the list of directories, that will be used to
;; search of "local" include files (if names are starting with /, this means,
;; that path is specified relative to project's root directory).
;; Instead of specifying paths as lists, you can also provide function, \
;; that will perform search of include files in your project. You can read about it in the EDE manual.
;;
;; Another parameter, that could be specified in project's declaration is a list of definitions,
;; that will be used during code preprocessing. The :spp-table parameter allows to specify
;; list of pairs, consisting from symbol's name & value, defined for given symbol.
;; In our example above, we defined two symbols — isUnix and BOOST_TEST_DYN_LINK,
;; that will be passed to preprocessor, and this will allow to perform proper parsing of the code.
;;
;; User, if required, can redefine some variables for files inside project.
;; This could be done by specifying the :local-variables parameter with value that
;; is a list of pairs in form symbol name/value,
;; and these values will be set for files in project.
;;
;;
;; Preprocessing of source code
;; More information about definitions for C/C++ preprocessor you can find in documentation
;; for the semantic-lex-c-preprocessor-symbol-map variable.
;; You can obtain list of preprocessor symbols, defined for file with source code,
;; by using the semantic-lex-spp-describe command.
;; And then use these results to set :spp-table parameter or
;; semantic-lex-c-preprocessor-symbol-map variable.
;;
;; Many libraries store all macro definitions in one or more include files,
;; so you can use these definitions as-is.
;; To do this you need to specify these files in the semantic-lex-c-preprocessor-symbol-file variable,
;; and when CEDET will perform analysis, then values from these files will be used.
;; By default, this variable has only one value — file with definitions for C++ standard library,
;; but you can add more data there. As example, I want to show CEDET's configuration for work with Qt4:
;;
;;
;;(setq qt4-base-dir "/usr/include/qt4")
;;(semantic-add-system-include qt4-base-dir 'c++-mode)
;;(add-to-list 'auto-mode-alist (cons qt4-base-dir 'c++-mode))
;;(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig.h"))
;;(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qconfig-dist.h"))
;;(add-to-list 'semantic-lex-c-preprocessor-symbol-file (concat qt4-base-dir "/Qt/qglobal.h"))
;;
;;
;; After you'll add these lines to initialization file,
;; you should be able to use names completion for classes, defined in Qt4 library.
;;
;;
;; Using EDE for Java projects
;; Semantic includes a parser for source code written in Java,
;; so name completion for source code always worked,
;; and the main problem was to get name completions for classes from JDK,
;; or other libraries that are used in project.
;; For compiled code, Semanticdb can get information about name by using javap
;; on the list libraries in the CLASSPATH.
;; To make it working, you need to load the semantic/db-javap package:
;;(require 'semantic/db-javap)
;;
;;
;; The path to the JDK's main library (rt.jar on Linux & Windows, and classes.jar on Mac OS X)
;; is usually detected automatically by the cedet-java-find-jdk-core-jar function,
;; although you can change its behaviour by setting JAVA_HOME environment variables,
;; or some other parameters.
;;
;; If you're using Maven to build your projects, then CLASSPATH will be calculating automatically
;; by running Maven in the root of your project (also for multi-module projects).
;; And it isn't necessary to specify project's root manually — EDE will find it automatically
;; by searching for the pom.xml file. I need to mention that first call to name completion functions
;; could be relatively slow — EDE should run Maven and collect information about libraries
;; that are used in the project.
;; But after first run, this information is cached, and next completions will be performed faster.
;;
;; If you aren't using Maven, then you can either specify all used libraries in the
;; semanticdb-javap-classpath variable, or use the ede-java-root-project class,
;; that is similar to ede-cpp-root-project that was described above.
;; To use this type of project, you need to add something like to you initialization file:
;;(ede-java-root-project "TestProject"
;;		       :file "~/work/TestProject/build.xml"
;;		       :srcroot '("src" "test")
;;		       :localclasspath '("/relative/path.jar")
;;		       :classpath '("/absolute/path.jar"))
;;
;; As for C/C++, you need to specify name of the project,
;; point to existing file at the project's root directory, and some additional options:
;; 
;; :srcroot
;; list of directories with source code.
;; Directory names are specified relatively of project's root (in this example this is src & test);
;;
;; :classpath
;; list of absolute file names for used libraries;
;;
;; :localclasspath
;; list of file names for used libraries, relative to project's root.
;;
;; When Semantic finds such project, it can use provided information for name completion.
;;
;;
;;
;; Work with Semantic
;; From user's point of view, Semantic provides several major features — names completions,
;; retrieving information about tags (variables, functions, etc.), and navigation in source code.
;; Some of these features are implemented by semantic/ia package, while other are implemented
;; by Senator, and Semantic's kernel.
;;
;; Some of commands have no standard key bindings, so it's better to select key bindings,
;; that are comfortable to you, and bind commands to them, like this (only for standalone CEDET):
(defun my-cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle))
(add-hook 'c-mode-common-hook 'my-cedet-hook)
;; I want to mention, that Semantic's development is pretty active,
;; and if something doesn't work, or works wrong, then please,
;; send examples of code to the cedet-devel mailing
;; list — the CEDET's authors usually answers pretty fast.;
;;
;;
;; Names completion
;; Text completion for names of functions, variables & classes is pretty often used feature
;; when you work with source code. There are two packages inside Semantic that implement this
;; functionality — semantic/ia and Senator (it doesn't included into GNU Emacs).
;; You need to take into account, that in the new versions it's recommended to use Semantic only
;; as source of information, and perform names completion using other packages,
;; such as auto-complete. You see example below.
;;
;; Commands, implemented by semantic/ia use the semantic-analyze-possible-completions
;; function to create a list of all possible names completion, and this function takes
;; into account many parameters (plus it can be augmented by user's
;; code to provide more precise list of names). At the same time,
;; commands from Senator package use simpler methods to create a list of all possibles completions
;; (usually they use information only about definitions in the current file),
;; and this sometime lead to wrong names completion.
;;
;; If you execute the semantic-ia-complete-symbol command when you're typing code,
;; then this will lead to completion of corresponding name — name of function,
;; variable, or class member, depending on the current context.
;; If there are several possible variants, then this name will be completed to most common part,
;; and if you'll call this command second time, then buffer with all possible completions will be shown.
;; User can also use the semantic-ia-complete-symbol-menu command —
;; it also performs analysis of current context, but will display list of possible
;; completions as a graphical menu, from which the required name should be selected.
;; Besides this, there is semantic-ia-complete-tip command,
;; that displays list of possible completions as tooltip.
;;
;; As was mentioned above, the Senator package, also provides commands for names completion.
;; It work very fast, but with less precision (as they use few parameters during computation of
;; variants for completions). The senator-complete-symbol command (C-c , TAB)
;; completes name for current tag, and insert first found completion as result.
;; If it inserts wrong name, then you can insert second name from completion list by
;; repeating this command, and so on. If there are a lot of the possible variants,
;; or you want to see full list of functions and variables for some class,
;; then it's better to use the senator-completion-menu-popup command (C-c , SPC) — it displays
;; list of all possible completions as a graphical menu.
;;
;; Besides these commands, user can use special mode (only for some languages) —
;; semantic-idle-completions-mode (or enable it globally by adding
;; global-semantic-idle-completions-mode symbol into semantic-default-submodes list) —
;; in this mode names completions are shown automatically if user stops its work for a some time
;; (idle time). By default, only first possible completion is shown,
;; and user can use the TAB key to navigate through list of possible completions.
;;
;;
;; For C-like languages, user can use the semantic-complete-self-insert command,
;; bound to the . and/or > keys, as this shown below:
(defun my-c-mode-cedet-hook ()
  (local-set-key "." 'semantic-complete-self-insert)
  (local-set-key ">" 'semantic-complete-self-insert))
(add-hook 'c-mode-common-hook 'my-c-mode-cedet-hook)
;; Evaluation of this code will lead to execution of the semantic-complete-self-insert
;; command when user will press . or > after variables, that are instances of some data structure,
;; and displaying a list of possible completions for given class or structure.
;;
;; If you're programming in C & C++, then you can also get name completions using information
;; from Clang (versions 2.9 & above). To do this, you need to load the semantic/bovine/clang package,
;; and call the semantic-clang-activate function. After that,
;; Semantic will start to call Clang, and use its code analyzer to
;; calculate list of possible names completions.
;;
;;
;; Getting information about tags
;; The semantic/ia package provides several commands,
;; that allow to get information about classes, functions & variables
;; (including documentation from Doxygen-style comments).
;; Currently following commands are implemented:
;;
;;
;; semantic-ia-show-doc
;; shows documentation for function or variable, whose names is under point.
;; Documentation is shown in separate buffer.
;; For variables this command shows their declaration, including type of variable,
;; and documentation string (if it's available).
;; For functions, prototype of the function is shown,
;; including documentation for arguments and returning value
;; (if comments are available);
;;
;; semantic-ia-show-summary
;; shows documentation for name under point, but information is shown in the mini-buffer,
;; so user will see only variable's declaration or function's prototype;
;;
;; semantic-ia-describe-class
;; asks user for a name of the class, and return list of functions & variables,
;; defined in given class, plus all its parent classes. 
;;
;;
;; Navigation in source code
;; One of the most useful commands for navigation in source code is the semantic-ia-fast-jump command,
;; that allows to jump to declaration of variable or function, whose name is under point.
;; You can return back by using the semantic-mrub-switch-tag command (C-x B),
;; that is available when you enable the semantic-mru-bookmark-mode minor mode.
;;
;; Semantic also provides two additional commands for jumping to function or variable:
;; defined in current file — semantic-complete-jump-local (C-c , j),
;; or defined in current project — semantic-complete-jump (C-c , J).
;; Both commands allow to enter name of function or variable
;; (including local variables inside functions) and jump to given definition
;; (you can use name completion when entering the name).
;;
;; The main difference between semantic-ia-fast-jump & semantic-complete-jump
;; commands is that the first properly handles complex names,
;; like this::that->foo(), while the second, can find only simple names, like foo.
;;
;; The semantic-analyze-proto-impl-toggle command allows to switch between function's declaration
;; and its implementation in languages, that allow to have separate declaration and implementation
;; of functions. Another useful command is semantic-decoration-include-visit,
;; that allows to jump to include file, whose name is under cursor.
;;
;; Senator provides several commands for navigation in source code. This is senator-next-tag (C-c , n)
;; and senator-previous-tag (C-c , p) commands, that move cursor to next or previous tag.
;; There is also the senator-go-to-up-reference command (C-c , u),
;; that moves cursor to the "parent" tag (for example, for class member function,
;; "parent" tag is class declaration).
;;
;; Search for places where function is called
;; Semantic also has very useful command — semantic-symref,
;; that allows to find places, where symbol (whose name is under point) is used in your project.
;; If you want to find use of symbol with arbitrary name, then you can use the semantic-symref-symbol
;; command, that allows to enter name of the symbol to lookup.
;;
;; If references to given name weren't found in corresponding database (GNU Global, etc.),
;; then these commands will try to find them using the find-grep command.
;; As result of execution of these commands, a new buffer with results will be created,
;; and user can jump to found places:
;;
;;
;;
;; Source code folding
;; As Semantic has almost complete syntactic information about source code,
;; this allows it to implement folding functionality, similar to functionality implemented
;; by hideshow package. To enable this feature, you need to perform customization of the
;; global-semantic-tag-folding-mode variable. When you'll enable it,
;; this will lead to displaying of small triangles at the fringle field,
;; and you will able to fold and unfold pieces of code by clicking on them
;; (this should work not only for source code, but also for comments, and other objects).
;;(global-semantic-tag-folding-mode 1)
;; Senator also has similar functionality, but it's usually used for top-level objects —
;; functions, class declarations, etc. You can fold piece of code with the senator-fold-tag
;; command (C-c , -), and unfold it with senator-unfold-tag (C-c , +).
;;
;; More Senator's commands
;; The Senator package provides number of commands for work with tags,
;; that allow user to cut or copy tag, and insert it in another place.
;; To cut current tag (usually this is declaration of some function, or its implementation)
;; the senator-kill-tag command (C-c , C-w) should be used.
;; You can insert complete tag with standard key binding C-y, while the senator-yank-tag
;; command (C-c , C-y) inserts only tag declaration, without body.
;; Another useful command is senator-copy-tag (C-c , M-w), that copies current tag —
;; this is very handy when, for example, you want to insert declaration of function into include file.
;;
;; Senator allows to change behaviour of standard search commands
;; (re-search-forward, isearch-forward and other), when you work with source code,
;; such way, so they will perform search only in the given tags.
;; To enable this mode you can use the senator-isearch-toggle-semantic-mode command(C-c , i),
;; and with the senator-search-set-tag-class-filter command (C-c , f)
;; you can limit search to given tag types — function for functions, variable for variables, etc.
;;
;; You can also perform tags search without enabling this mode —
;; you just need to call corresponding command: senator-search-forward or senator-search-backward.
