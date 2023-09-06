status is-interactive; or return
#
# function _complete-eagerly_install --on-event _complete-eagerly_install
#
#     # Set universal variables, create bindings, and other initialization logic.
# end
#
# function _complete-eagerly_update --on-event _complete-eagerly_update
# 	# Migrate resources, print warnings, and other update logic.
# end
#
# function _complete-eagerly_uninstall --on-event _complete-eagerly_uninstall
# 	# Erase "private" functions, variables, bindings, and other uninstall logic.
# end

# commandline --function accept-autosuggestion
# commandline --function expand-abbr
# commandline --function complete
# commandline --function complete-and-search
# commandline --function suppress-autosuggestion

# commandline --is-valid # Return true if the current commandline is syntactically valid and complete.
# commandline --paging-mode
# commandline --paging-full-mode
# commandline --search-mode

# TODO: <kpbaks 2023-09-05 22:54:00> make smarter
function __complete-eagerly.fish::space
    set --local buffer (commandline)
    # set --local before (commandline --cut-at-cursor)
    # NOTE: " " is normally used to expand abbreviations, so we need to
    # do it, otherwise the users abbreviation will not work.
    commandline --function expand-abbr
    commandline --insert " "
    if test (string trim -- $buffer) = ""
        # Do not want to complete if the user has not typed anything yet.
        return
    end
    commandline --is-valid; or return
    # set --local tokens (commandline --tokenize)
    # set --local prog $tokens[1]
    # type --query $prog; or return
    commandline --function complete
end

function __complete-eagerly.fish::hyphen
    set --local buffer (commandline)
    # commandline --function expand-abbr
    commandline --insert -
    if test (string trim -- $buffer) = ""
        # Do not want to complete if the user has not typed anything yet.
        return
    end
    commandline --is-valid; or return

    commandline --function complete
end

function __complete-eagerly.fish::dollar
    set --local buffer (commandline)
    # commandline --function expand-abbr
    commandline --insert \$
    if test (string trim -- $buffer) = ""
        # Do not want to complete if the user has not typed anything yet.
        return
    end

    commandline --function complete
end

function __complete-eagerly.fish::backspace
    set --local buffer (commandline)
    commandline --function backward-delete-char
    if test (string trim -- $buffer) = ""
        # Do not want to complete if the user has not typed anything yet.
        return
    end

    commandline --function complete
end

set --local mode default
bind --mode $mode " " __complete-eagerly.fish::space
bind --mode $mode - __complete-eagerly.fish::hyphen
bind --mode $mode \$ __complete-eagerly.fish::dollar
# FIXME: <kpbaks 2023-09-06 20:00:17> does not get registered properly. It is like the `preset`
# binding still remains.
# bind backspace __complete-eagerly.fish::backspace
# bind --mode default z __complete-eagerly.fish::backspace



# TODO: <kpbaks 2023-09-06 20:03:02> See if you can make this work
# with all characters in the alphabet. That would be cool.
#
# for char in a e o
#     eval "function __complete-eagerly.fish::$char
#         set --local buffer (commandline)
#         # commandline --function expand-abbr
#         commandline --insert $char
#         if test (string trim -- \$buffer) = ''
#             # Do not want to complete if the user has not typed anything yet.
#             return
#         end
#
#         commandline --function complete
#     end"
#     bind --mode default $char __complete-eagerly.fish::$char
# end
