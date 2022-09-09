# PROJECT GOLD RUSH
# NATALIA PEREZ
# CSC 35-02

.intel_syntax noprefix
.data
Title:
    .ascii "             +___+         |===|          +___+             \n"
    .ascii "             |   |        ++   ++         |   |             \n"
    .ascii "             |{$}|  ====================  |{$}|             \n"
    .ascii "             |   |  CALIFORNIA GOLD RUSH  |   |             \n"
    .ascii "             +___+  ====================  +___+             \n\0"

Rules:
    .ascii "\n"
    .ascii "                        ===========  \n"
    .ascii "                           RULES     \n"
    .ascii "                        ===========  \n"
    .ascii "1. 20 weeks [5 MONTHS] \n"
    .ascii "2. Your endurance drops 10-25% each week. If it reaches 0%, the game ends. \n"
    .ascii "3. Panning for gold yields $0-$100. \n"
    .ascii "4. A sluice yields $0-$1000. [DURABILITY DROPS 20-50% EACH WEEK] \n"
    .ascii "5. Food costs $30-$50. \n\0"

Choice:
    .ascii "                      ==============                 \n"
    .ascii "      +      +    PLEASE SELECT A CHOICE    +      + \n"
    .ascii "                +     ==============     +           \n"
    .ascii "1. Do nothing                                 \n"
    .ascii "2. Repair sluice [-$100]                      \n"
    .ascii "3. Go to town                                 \n\n\0"

WeekPrint:
    .ascii "\nWEEK \0"

FundsPrint:
    .ascii "\nYou have $\0"

EndurancePrint:
    .ascii "\nYour endurance is at \0"

SluicePrint:
    .ascii "Sluice is at \0"

PercentageSign:
    .ascii "%\n\0"

SluiceRepair:
    .ascii "\nYou repaired the sluice to 100%.\n\0"

GoingToTown:
    .ascii "    ~         ~          __          \n"
    .ascii "        _T      .,,.   ~--~ ^^       \n"
    .ascii "   ^^  // \\                     ~   \n"
    .ascii "       ][0]    ^^     ,-~ ~          \n"
    .ascii "    /''-I_I         _II______         \n"
    .ascii "   /_   /  \\______/ ''     /'\\_,__   \n"
    .ascii "  |   II--''' \\,--:--..,_ /,.-{ },   \n"
    .ascii "; '/ /__\\,.--'|    |[] .-.| 0{   }   \n"
    .ascii ":'   |  | [] -|    ''--:.;[,.'\\./    \n"
    .ascii "'    |[]|,.--'' ''   ''-,.     |     \n"
    .ascii "    ..    ..-''   ;       ''.  '     \n"
    .ascii "\nGoing to town costed you $\0"

Panning:
    .ascii "\nPanning for gold yields $\0"

SluiceYields:
    .ascii "\nYour sluice yields $\0"

SluiceBroken:
    .ascii "\nYour sluice is broken.\n\0"

FoodCosts:
    .ascii "\nYou ate $\0"

EndOfFood:
    .ascii " in food\n\0"

Regain:
    .ascii "\nYou regained \0"

EndurancePart:
    .ascii "% endurance. \n\0"

EndGame:
    .ascii "      ============ \n"
    .ascii "       GAME OVER  \n"
    .ascii "      ============ \n\0"

EndFunds:
    .ascii "You ended the game with $\0"

EndEndurance:
    .ascii "\nYour endurance was \0"

Funds:
    .quad 100

Sluice:
    .quad 100

Endurance:
    .quad 100

Week:
    .quad 1

Cost:
    .quad 0

Gain:
    .quad 0

Loss:
    .quad 0

.text
.global _start

_start:

    lea rbx, Title
    call PrintCString

    lea rbx, Rules
    call PrintCString
    
    #The player is prompted to make their selection. Once their selection is made,
    #their funds, endurance, and sluice durability is effected.

    While:
        lea rbx, WeekPrint
        call PrintCString

        lea rax, Week
        MOV rbx, [rax]
        call PrintInt        
        MOV [rax], rbx

        lea rbx, FundsPrint
        call PrintCString

        lea rcx, Funds
        MOV rbx, [rcx]
        call PrintInt
        MOV [rcx], rbx

        lea rbx, EndurancePrint
        call PrintCString

        lea rax, Endurance
        MOV rbx, [rax]
        call PrintInt
        MOV [rax], rbx

        lea rbx, PercentageSign
        call PrintCString

        lea rbx, SluicePrint
        call PrintCString

        lea rcx, Sluice
        MOV rbx, [rcx]
        call PrintInt
        MOV [rcx], rbx

        lea rbx, PercentageSign
        call PrintCString

        lea rbx, Choice
        call PrintCString

        call ScanInt    #Scans from user and inputs in rbx
        cmp rbx, 2      #If choice is 2
        je IfTwoOrMore

        #FALSE BLOCK
        cmp rbx, 3
        je IfThree

        IfOne:
           jmp PartTwo

        IfTwoOrMore:
           cmp rbx, 1
           je IfOne

           lea rcx, Funds
           MOV rbx, [rcx]
           cmp rbx, 100
           jl IfThree

           #Reset the Sluice to 100%
           lea rcx, Sluice
           MOV rbx, [rcx]
           IMUL rbx, 0
           MOV rbx, rax
           MOV rbx, 100
           lea rcx, Sluice
           MOV [rcx], rbx
  
           lea rbx, SluiceRepair
           call PrintCString
         
           #Since the player chose to repair the sluice, $100 is subtracted from their balance.
           lea rcx, Funds
           MOV rbx, [rcx]
           SUB rbx, 100
           lea rcx, Funds
           MOV [rcx], rbx
        
           jmp PartTwo
           #END IF
          
        IfThree:
           lea rbx, GoingToTown
           call PrintCString
           MOV rbx, 151
           call Random
           ADD rbx, 100
           call PrintInt
           lea rax, Cost
           MOV [rax], rbx
           
           #Funds = Funds - Cost
           lea rcx, Funds
           MOV rbx, [rcx]
           lea rax, Cost
           SUB rbx, [rax]
           MOV [rcx], rbx
           
           #Assign Gain to be a random number from 5-50
           lea rbx, Regain
           call PrintCString
           
           MOV rbx, 46
           call Random
           ADD rbx, 5

           call PrintInt
           lea rcx, Gain
           MOV [rcx], rbx
           lea rbx, EndurancePart
           call PrintCString
           
           #Endurance = Endurance + Gain
           lea rax, Endurance
           MOV rbx, [rax]
           lea rcx, Gain
           ADD rbx, [rcx]
           MOV [rax], rbx
           
           jmp PartTwo
           #END IF
   PartTwo:
        #PART 2: Gains
        #Gain = random number between 0 - 100
        lea rbx, Panning
        call PrintCString

	MOV rbx, 101
        call Random
        call PrintInt
        lea rcx, Gain
        MOV [rcx], rbx

        #Add Gain to Funds
        lea rcx, Funds
        MOV rbx, [rcx]
        lea rcx, Gain
        ADD rbx, [rcx]
        lea rcx, Funds
        MOV [rcx], rbx

        jmp SluiceCompare

    SluiceCompare:
        #If Sluice >= 1
        lea rcx, Sluice
        MOV rbx, [rcx]
        cmp rbx, 1
        jge IfSluiceGEO

        #If Sluice < 1 // FALSE BLOCK
        lea rbx, SluiceBroken
        call PrintCString
        jmp PartThree

        IfSluiceGEO:
            #Gain = random number between 0 - 1000
            lea rbx, SluiceYields
            call PrintCString

            MOV rbx, 1001
            call Random
            call PrintInt
            lea rcx, Gain
            MOV [rcx], rbx
            
            #Add Gain to Funds
            lea rcx, Funds
            MOV rbx, [rcx]
            lea rcx, Gain
            ADD rbx, [rcx]
            lea rcx, Funds
            MOV [rcx], rbx
            
            jmp PartThree
            #END IF

    PartThree:
        #Part 3: Costs
        #Cost = random number between 30 - 50
        lea rbx, FoodCosts
        call PrintCString

        MOV rbx, 21
        call Random
        ADD rbx, 30

        call PrintInt
        lea rax, Cost
        MOV [rax], rbx
        lea rcx, Funds
        MOV rbx, [rcx]
        lea rax, Cost
        SUB rbx, [rax]        
        lea rcx, Funds
        MOV [rcx], rbx


        lea rbx, EndOfFood
        call PrintCString

        #Part 4: Wear & Tear
        #Loss = random number between 10 - 25
        MOV rbx, 16
        call Random
        ADD rbx, 10
        lea rax, Loss
        MOV [rax], rbx

        #Endurance = Endurance - Loss
        lea rax, Endurance
        MOV rbx, [rax]
        lea rax, Loss
        SUB rbx, [rax]
        lea rax, Endurance
        MOV [rax], rbx
        
        #Loss = random number between 20 - 50
        MOV rbx, 31
        call Random
        ADD rbx, 20        
        lea rax, Loss
        MOV [rax], rbx
        
        #Sluice = Sluice - Loss
        lea rcx, Sluice
        MOV rbx, [rcx]
        lea rax, Loss
        SUB rbx, [rax]
        lea rcx, Sluice
        MOV [rcx], rbx

        #Add 1 to week
        lea rax, Week
        MOV rbx, [rax]
        ADD rbx, 1

        cmp rbx, 20
        jg GameOver

        #Otherwise
        lea rax, Week
        MOV [rax], rbx

        lea rax, Endurance
        MOV rbx, [rax]
        cmp rbx, 0
        jle GameOver

        #Otherwise
        lea rax, Endurance
        MOV [rax], rbx
 
        jmp While

    GameOver:
        lea rbx, EndGame
        call PrintCString
        lea rbx, EndFunds
        call PrintCString

        lea rcx, Funds
        MOV rbx, [rcx]
        call PrintInt
        MOV [rcx], rbx

        lea rbx, EndEndurance
        call PrintCString

        lea rax, Endurance
        MOV rbx, [rax]
        call PrintInt
        MOV [rax], rbx

        lea rbx, PercentageSign
        call PrintCString

        call EndProgram
