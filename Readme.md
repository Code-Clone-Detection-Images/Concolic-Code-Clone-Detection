# Concolic Code Clone Detection

Run [CCCD](https://web.archive.org/web/20150921003732/https://www.se.rit.edu/~dkrutz/CCCD/index.html?page=install) on a supplied folder.

**Build** using the [`makefile`](makefile).
**Run** using the [run-script](run.sh) script, supply it with the project folder.

> As only the `pwd` (current working directory) will be mounted automatically, you can not specify files/folders located in upper levels.

Example:

```bash
make
./run.sh c-small
```

After running, the supplied folder will contain a toplevel `.csv` named `<folder>_comparisionReport.csv` (the typo is intentional in this Readme and a typo within CCCD). It contains all detected combinations alongside their 'LevenDistance' (as produced by CCCD). If you are interest in how we did classify these distances, take a look at [list-clones.py](analysis/list-clones.py) which performs the classification inside of the container.
