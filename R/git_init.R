git_init <- function(){
  if(system('git --version') != 0) {
    print("check if git is installed") 
  } else if(file.exists('.git')) {
    print(".git already exists")
  } else {
    system('git init')
    system("git add .")
    system("git commit -am 'auto init commit'")
    system('git checkout -b devel')
  }
}