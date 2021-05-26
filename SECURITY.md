# Security Policy

## Supported Versions

Use this section to tell people about which versions of your project are
currently being supported with security updates.
| Branch name |Info|
| ----------- | -------------------------------------------------------------------- |
| Master      | The master branch maintains the latest release code of the released product, merges from Release or Feature to the official release history|
| Feature     | Opened from the Master branch, it is mainly used to develop new features or special test sets, which are maintained according to the responsible module; the naming convention is: feature/#..., each function should correspond to an issue,...is an issue number. |
| Hotfix      |	Opened from the Master branch, it is mainly used to fix known bugs in the currently released version; please refer to Bugfix for precautions when solving bugs. The naming convention is：hotfix/#... |
| Release	  | It is opened from the Master branch and is mainly used to release the version. Once the Master branch has enough functions to do a release (or the scheduled release day), fork a release branch from the Master branch. The newly created branch is used to start the release cycle. This branch should only be used for bug fixes, document generation, and other release-oriented tasks. Once the external release work is completed, perform the following three operations: merge the Release branch to the Master; tag the Master with the corresponding version; Release returns, and these changes since the new release branch must be merged back into the Master branch. The naming convention is：release/...，...as release No.|
| ngihtly     | Build every night to verify the examples and public libraries of the test suite to ensure that the relevant scripts are available.|

> [!IMPORTANT]
> Master tag To test the version number of the code base itself
> Releas tag Sync with the release/-x-tag of the product to be tested; if the tested product is 2.0.0-rc1, you can pull out a release/2.0.0-rc1
> Hotfix tag Same as the hostfix of the tested product, a hotfix can be pulled out during the test/#window stuck
> Feature tag Independently developed and researched feature prototype verification can pull a feature such as feature/#requirement or bug

* System testing and iterative testing can directly pull the latest code (tag) of the Master branch
* All Feature, Hotfix, and Release that have been debugged and verified must be merged into the Master


## Reporting a Vulnerability

If some body find a vulnerability, can just create a issues or submit a pull request!.

I will check and response weekly for you.

Any one can also contact me directly by Gitter, Email or slack etc.
