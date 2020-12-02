--- 
title: "The RJafroc Book"
author: "Dev P. Chakraborty, PhD"
date: "2020-12-02"
site: bookdown::bookdown_site
output: 
   bookdown::pdf_document: default
documentclass: book
bibliography: [packages.bib, myRefs.bib]
biblio-style: apalike
link-citations: yes
github-repo: dpc10ster/RJafrocBook
description: "Updated observer-performance book based on RJafroc."
---





# Preface {-}
* This book is currently (as of November 2020) in preparation. 
* It is intended as an online update to my "physical" book [@chakraborty2017observer]. Since its publication in 2017 the `RJafroc` package, on which the `R` code examples in the book depend, has evolved considerably, causing many of the examples to "break". This also gives me the opportunity to improve on the book and include additional material.
* The physical book chapters are labeled (book), to distinguish them from the chapters in this online book.

## A note on the online distribution mechanism of the book {-}
* In the hard-copy version of my book [@chakraborty2017observer] the online distribution mechanism was `BitBucket`. 
* `BitBucket` allows code sharing within a _closed_ group of a few users (e.g., myself and a grad student). 
* Since the purpose of open-source code is to encourage collaborations, this was, in hindsight, an unfortunate choice. Moreover, as my experience with R-packages grew, it became apparent that the vast majority of R-packages are shared on `GitHub`, not `BitBucket`. 
* For these reasons I have switched to `GitHub`. All previous instructions pertaining to `BitBucket` are obsolete.
* In order to access `GitHub` material one needs to create a (free) `GitHub` account. 
* Go to [this link](https://github.com) and click on `Sign Up`.

## Contributing to this book {-}
* I appreciate constructive feedback on this document, e.g., corrections, comments, etc.  
* To do this raise an `Issue` on the `GitHub` [interface](https://github.com/dpc10ster/RJafrocBook). 
* Click on the `Issues` tab under `dpc10ster/RJafrocBook`, then click on `New issue`.
* When done this way, contributions from users automatically become part of the `GitHub` documentation/history of the book.

## Is this book relevant to you and what are the alternatives? {-}
* Diagnostic imaging system evaluation
* Detection
* Detection combined with localization
* Detection combined with localization and classificatin
* AI
* CV
* Alternatives

## ToDos {-}
* Check Bamber theorem derivation.
* Parts labeled TBA and TODOLAST need to be updated on final revision.
* Change third person to first person in references to myself.

## Chapters needing heavy edits {-}
* 12-froc.
* 13-froc-empirical.
* 13-froc-empirical-examples.


