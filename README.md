# Overview
This implements a Tax calculator in Ruby based on some requirements. Test library is [RSPec](https://rspec.info/) with [Simplecov](https://github.com/simplecov-ruby/simplecov) for coverage analysis.

<br>

Project is an MVP with room for improvement. Potential areas for improvement are..
- EU Country codes and tax rates are hardcoded, but change with time in the real world. This may be improved to dynamically fetch from an API
- Country codes are validated only against hardcoded values, and not for accuracy in the real world
- Incomplete ...
