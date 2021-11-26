module type_vector2
    use, intrinsic :: iso_fortran_env
    implicit none
    private
    public :: vector2
    public :: clear

    type :: vector2
        real(real64) :: x
        real(real64) :: y
    end type

    interface clear
        procedure :: clear_vector2
    end interface

contains
    subroutine clear_vector2(vec)
        use, intrinsic :: iso_fortran_env
        implicit none
        type(vector2), intent(inout) :: vec
        vec%x = 0d0
        vec%y = 0d0
    end subroutine clear_vector2
end module type_vector2
