;; its somewhere in this mess but its so hard to find what defines certain variables, like libx11 for example.
(use-modules (guix packages)
             (guix build-system cmake)
             (guix git-download)
             (gnu packages guile)
             (guix licenses)
             (gnu packages xorg)
             (gnu packages ninja)
             (gnu packages kde-frameworks)
             (gnu packages java)
             (gnu packages package-management)
             ;; (guix gexp)
             ;; (guix packages)
             ;; (guix download)
             ;; (guix git-download)
             ;; (guix build-system copy)
             ;; (guix build-system gnu)
             ;; (guix build-system meson)
             ;; (guix build-system cmake)
             ;; (guix build-system python)
             ;; (guix utils)
             ;; (gnu packages)
             ;; (gnu packages aidc)
             ;; (gnu packages anthy)
             ;; (gnu packages autotools)
             ;; (gnu packages base)
             ;; (gnu packages bash)
             ;; (gnu packages bison)
             ;; (gnu packages check)
             ;; (gnu packages cups)
             ;; (gnu packages compression)
             ;; (gnu packages digest)
             ;; (gnu packages emacs)
             ;; (gnu packages flex)
             ;; (gnu packages fonts)
             ;; (gnu packages fontutils)
             ;; (gnu packages freedesktop)
             ;; (gnu packages gettext)
             ;; (gnu packages gl)
             ;; (gnu packages glib)
             ;; (gnu packages gnupg)
             ;; (gnu packages gperf)
             ;; (gnu packages gtk)
             ;; (gnu packages haskell-xyz)
             ;; (gnu packages inkscape)
             ;; (gnu packages image)
             ;; (gnu packages imagemagick)
             ;; (gnu packages libedit)
             ;; (gnu packages linux)
             ;; (gnu packages llvm)
             ;; (gnu packages m4)
             ;; (gnu packages ncurses)
             ;; (gnu packages onc-rpc)
             ;; (gnu packages pciutils)
             ;; (gnu packages perl)
             ;; (gnu packages perl-check)
             ;; (gnu packages pkg-config)
             ;; (gnu packages python)
             ;; (gnu packages python-compression)
             ;; (gnu packages python-crypto)
             ;; (gnu packages python-xyz)
             (gnu packages qt)
             ;; (gnu packages spice)
             ;; (gnu packages video)
             ;; (gnu packages xiph)
             ;; (gnu packages xml)
             ;; (gnu packages xdisorg)
             ;; (guix packages libx11)
             ;; (guix packages libxrender)
             ;; (guix packages libxext)
             )
(package
  (name "prism")
  (version "0.8.4")
  (source
   (origin
     (method git-fetch)
     (uri (git-reference
           (recursive? #t)
           (url "https://github.com/PrismLauncher/PrismLauncher")
           (commit "a58f7bf240c7a5a52c1279fdd225c825677793b6")))
     (file-name (git-file-name name version))
     (sha256
      (base32 "07ngh55rqxslrs3q1qlydxavxcc39dmxsgqnlv7xmn13ci1n5vsr"))))
  (build-system cmake-build-system)
  (inputs (list libx11
                libxrender
                qtbase
                qt5compat
                `(,openjdk17 "jdk")
                openjdk16
                icedtea
                libxext
                ninja
                extra-cmake-modules))
  (arguments
   `( #:tests? #f ;Run the test suite (this is the default)
     ;; #:configure-flags '("-S" "." "-B" "build" "-G" "Ninja" "-DCMAKE_INSTALL_PREFIX=install" "--verbose")
     #:phases (modify-phases %standard-phases
                (add-after 'unpack 'fix-hardcoded-paths;;setup-environment
                  ;;(replace 'configure
                           (lambda _
                            (display "configure ninja")
                             (invoke "cmake"
                                     "-S"
                                     "."
                                     "-B"
                                     "build"
                                     "-G"
                                     "Ninja"
                                     "-DCMAKE_INSTALL_PREFIX=install")
                              (display "building prism")
                             (invoke "cmake" "--build" "build")
                             (display "installing prism")
                             (invoke "cmake" "--install" "build")
                             (display "installing prism component")
                             (invoke "cmake" "--install" "build" "--component"
                                     "portable"))))));;)
  (home-page "https://prismlauncher.org/")
  (synopsis
   "An Open Source Minecraft launcher")
  (description
   "An Open Source Minecraft launcher with the ability to manage multiple instances, accounts and mods. Focused on user freedom and free redistributability.")
  (license gpl3+))
