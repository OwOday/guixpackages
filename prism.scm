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
             (gnu packages qt)
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
