# README

Tried to maintain the clean code architecture of this https://github.com/chicks/aes gem.

# Root AES class:

* `encrypt` and `decrypt` method
  - Not changed anything

* `key` and `iv` method
  - added guard clause istead of `(case/when)`. For two condition `(case/when)` seems a bit lengthy code which can be easily done by gurad clause with `return`
  - Added a private method for the `key` and `iv` method. Because two methods logic is almost same expect the item type. That's why passed item as a parameter for this method.
