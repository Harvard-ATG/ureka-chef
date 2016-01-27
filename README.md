Harvard ATG's ureka cookbook
=============================

ureka (0.1.0) Installs/Configures ureka

Installs/Configures ureka

Requirements
------------

### Platforms

### Dependencies

`yum ~> 3.5.2`

`ssh ~> 0.10.10`

`git >= 0.0.0`

`python ~> 1.4.6`

`build-essential ~> 2.2.4`


Attributes
----------


Recipes
-------

Testing and Utility
-------
    <Rake::Task default => [test]>

    <Rake::Task foodcritic => []>
      Run Foodcritic lint checks

    <Rake::Task integration => [kitchen:all]>
      Alias for kitchen:all

    <Rake::Task kitchen:all => [default-centos]>
      Run all test instances

    <Rake::Task kitchen:default-centos => []>
      Run default-centos test instance

    <Rake::Task readme => []>
      Generate the Readme.md file.

    <Rake::Task rubocop => []>
      Run RuboCop style and lint checks

    <Rake::Task rubocop:auto_correct => []>
      Auto-correct RuboCop offenses

    <Rake::Task spec => []>
      Run ChefSpec examples

    <Rake::Task test => [rubocop, foodcritic, spec]>
      Run all tests

License and Authors
------------------

The following engineers have contributed to this code:
 * [Josh Beauregard](https://github.com/sanguis) - 22 commits

Copyright:: 2016 Harvard ATG

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Contributing
------------

We welcome contributed improvements and bug fixes via the usual workflow:

1. Fork this repository
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new pull request
