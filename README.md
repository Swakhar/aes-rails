# README

Tried to maintain the clean code architecture of this https://github.com/chicks/aes gem.

__Root AES class:

* `encrypt` and `decrypt` method
  - Not changed anything

* `key` and `iv` method
  - added guard clause istead of `(case/when)`. For two condition `(case/when)` seems a bit lengthy code which can be easily done by gurad clause with `return`
  - Added a private method for the `key` and `iv` method. Because two methods logic is almost same expect the item type. That's why passed item as a parameter for this method.

__AES::AES class

* added `attr_reader` instead of `attr`. We only getter method of these attributes and removed two attr `cipher_text` and `plain_text` which is unnecessary of our current code logic.

* `encrypt` method
  - removed `(case/when)` logic and added gurad clause for this condition.
  - removed `@plain_text`. Previously it was needed just because to access in `_encrypt` method. Now we are passing the parameter's `plain_text` as a parameter of `_encrypt` method.
  - As ruby returns the last line of the method, so we do not need to assign `@cipher_text` here.

* `decrypt` method
  - Just removed the `(case/when)` logic and added guard clause for this condition.

* `random_key` method
  - exchanged `unpack` method with `unpack1`. As `unpack1` returns only `string`, then we do not need to fetch array's `[0]` index

private method

* _random_seed method
  - removed unnecessary return inside the `if` condition.
* merge_options method
  - added new ruby syntax here for `hash`.
* _handle_iv method
  - removed `(case/when)` logic and integrated with guard clause and simple if condition
* _setup method
  - small change in the last line for `@cipher.key`. Removed `block` from `map` method and added simply `map(&:hex)`, which looks good for me than previous and result is the same.
* b64_e_with_iv_and_encrypt method
  - added new private method which is actually used in `encrypt` method for break the long line.

__Removed all comments from the code.
