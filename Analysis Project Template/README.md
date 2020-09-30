# Analysis Project Template

This folder is an example setup for a clean analysis project. For more information, review the Principles of Workflow (YouTube, article, presentation).

This is an example of a fairly mature Repo for a complicated analysis. It might be used for a 3-month project, for an academic research paper, or other project with multiple analyses and presentations. For many analysts, the more typical scenario will be to mimic this Repo layout without the subfolders (everything is top level). Another frequent setup is to have a Repo entitled “Data Requests,” where each folder is dedicated to a specific data request and has no more than 2 or 3 files. 

Make the Repo work for you, but *keep it organized* and *keep your README up to date*.

## Repo structure

* **README.** Brief description of what the Repo’s purpose is, what the Repo contains, and any other information that a future analyst might find helpful.
* **LICENSE.** It is polite to specify for other users how they can use the Repo’s contents. The MIT License is common, permissive, and easy to read.
* **.RProj** If you set up an R Project, do it at the top level of the Repo so that you can access all subfolders.
* **Analysis script (optional).** If your project is relatively small and has one or two analysis scripts, the top level of the Repo is a convenient place to store them.
* **Analysis folder (optional).** If your analysis is more complicated or has many scripts, store them in a single directory for easy reference.
* **Raw Data folder.** It is best practice *never to overwrite* any raw data. Keep a script that does the cleaning for you and saves into the Clean Data folder.
* **Clean Data folder.** This folder is safe to write to and delete from. Many projects will clean the raw data once, save to a new file in Clean Data, and subsequently reference  `clean_data.xlsx` / `clean_data.rds` for all future analysis.
* **Images folder.** If you save a lot of images (*e.g.,* graphs) for subsequent presentations, saving them together in a directory keeps your workspace clean.
* **Functions folder.** If you have only a few custom functions, feel free to call them directly in your analysis scripts. But if you have many or would like to use them across multiple scripts, save them in this directory and call them using `source()`. I sometime have `utils.R` and `functions.R` files in this directory. `utils.R` is for utility functions like `round_to_even()` or `apply_color_scheme()`. `functions.R` is for analysis-specific data manipulation or visualization such as `calculate_indicator_variables()`, `merge_datasets()`, or `generate_column_chart()`.

## Example workflow

1. Save a `raw_data.xlsx` file into the Raw Data directory
2. Create a `clean_data_script.R` in the Analysis directory to clean `raw_data.xlsx` and save `clean_data.xlsx` in the Clean Data directory.
3. Create a `primary_analysis.R` file in the Analysis directory. This file references `clean_data.xlsx` and saves any outputs to the Images directory
4. Create additional analysis files in the Analysis directory. Potentially create a `utils.R` and/or a `functions.R` file in the Functions directory as the codebase matures
5. Create a `final_presentation.rmd` in the top-level directory when I am ready to share my work
6. Along the way, keep the `README` up to date!

## Comment on integration with GitHub

The first rule of using GitHub is to adhere to whatever standards your team uses. In general, though, I recommend creating two branches: `master` and `dev`. The `master` branch has code that is “production ready.” All code there is final or at least mature enough to be the working version. The `dev` branch is where all the work gets done. Checkout this branch and commit to it as you go. Once you are ready to move something from `dev` to `master`, rebase (or merge, depending on your team’s preference).

## Comment on R Projects

What you won’t see in this repo that is in most (all?) of my analytics repos is an `.RProj` file. This file (and some hidden files that don’t get committed to GitHub) set up a project environment in RStudio. The environment has several advantages, including allowing for relative references to files using the project directory as the root. 

Fortunately for you, the R Project also integrates well with Git. Unfortunately for you, this means that getting everything onto GitHub purely for examples’ sake can be complicated (Google “Git submodule” and then cower in fear). So, I’ve left out the `.RProj` file. But ordinarily it’s easy to put one at the top of your Git directory. You should have one. 

It’s easy: RStudio > File > New Project > Existing Directory > Find your Directory > Create Project

When you want to work on your analytics project: RStudio > File > Open Project > Find your Project > Open