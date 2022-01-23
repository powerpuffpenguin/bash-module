# bash-module

[中文](README_zh.md)

This is a bash script writing specification, and the library created under this specification, its main purpose is to solve the modularization problem of bash script

* [Why](#Why)
* [Rule](#Rule)
* [API](document/en/README.md)
* [Install](#Install)
* [Define Module](#Define_Module)
* [Import Module](#Import_Module)

# Why

When I use more and more bash scripts, I find it more convenient, basically all *inix can be executed without additional dependencies. For example, if you want to run python or js in a docker, you also need a script running environment. The python or nodejs environment will make the docker bloated, but using bash script will not have these problems. In addition, there are environments such as msys that can run bash even on windows, which makes the usable range of bash wider.

However, bash does not have a good modularization scheme, so it becomes difficult to reuse code. Fortunately, bash is still flexible. Modularization can be achieved as long as it follows some specifications and encapsulates a little, so I created some modularization Specification and provides the basic package core.sh for this

# Rule

1. A script defines a module. The variables and functions provided by the module should have a uniform name prefix to avoid name conflicts. The name prefix is called **namespace**

    For example, a string processing module, its namespace can be strings

    ```
    # define variable
    strings_Version="v1.0.0"

    # Define the trim function
    function strings.trim
    {}
    ```

2. namespace should be all lowercase English words, usually the same as the file path stored in it. Multiple words are connected by **_**, for example:

    * strings
    * cache
    * cache_lru
    * cache_lru_timer

3. Modules should define a __module_flag_of_**namespace** variable at the beginning of the code to avoid being imported multiple times

    ```
    if [[ "$__module_flag_of_core_colors" == 1 ]];then
        return 0
    fi
    __module_flag_of_core_colors=1
    ```

4. Use camel case for global variable names and function names. Public variables and functions should be capitalized, and private ones should be lowercase.

5. Global variable name should use **_** connection name and namespace, private should use **__** connection name and namespace to avoid the final name and other namespace duplication

    ```
    # private variable
    strings__var
    # public variable
    strings_Var
    ```

6. Public functions should use **.** connection name and namespace, and private functions should use **._** connection name and namespace to avoid calling a public method with a wrong lowercase initial letter and calling a private method with the same name

    ```
    # private method
    function strings._hasPrefix
    {}
    # public method
    function strings.HasPrefix
    {}
    ```