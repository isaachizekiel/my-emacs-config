;; A Gentle introduction to CEDET
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
(semantic-mode 1)
;;
;;
;; To enable more advanced functionality for name completion, etc.,
;; you can load the semantic/ia with following command:
(require 'semantic/ia)
;;
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
;; limit search by customization of the semanticdb-find-default-throttle variable for concrete modes —
;; for example, don't use information from system include files,
;; by removing system symbol from list of objects to search for c-mode:
(setq-mode-local c-mode semanticdb-find-default-throttle
		 '(project unloaded system recursive))
;;
(setq-mode-local c++-mode semanticdb-find-default-throttle
		 '(project unloaded system recursive))
;;
;;
;; Integration with imenu
;; The Semantic package can be integrated with the imenu package.
;; This lead to creation of a menu with a list of functions, variables, and other tags.
;; To enable this feature you need to add following code into your initialization file:
;;
(semanticdb-enable-gnu-global-databases 'c-mode)  
(semanticdb-enable-gnu-global-databases 'c++-mode))
;;
;;
;; EDE's customization
;; If you plan to use projects, then you need to enable corresponding mode,
;; implemented by the EDE package:
(global-ede-mode t)
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
;;
(defun my-cedet-hook ()
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
  (local-set-key "\C-c?" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-c>" 'semantic-complete-analyze-inline)
  (local-set-key "\C-cp" 'semantic-analyze-proto-impl-toggle))
(add-hook 'c-mode-common-hook 'my-cedet-hook)
;;
;;
