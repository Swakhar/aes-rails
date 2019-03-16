# README

Tried to maintain the clean code architecture of this https://github.com/chicks/aes gem.

# Root AES class:

* encrypt method
  - Not changed anything

* decrypt method
  - Not changed anything

* key and iv method
  - added guard clause istead of (case/when). For two condition (case/when) seems a bit lengthy code which can be easily done by gurad clause with `return`
