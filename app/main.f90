program main
    use, intrinsic :: iso_fortran_env
    use :: type_vector2
    implicit none
    real(real64), parameter :: pi = acos(-1d0)

    integer(int32) :: num1, num2 !input number 1 and 2
    integer(int32) :: add, sub, mul, neg !add, subtruct, multiply, negate operations
    real(real64) :: div !division operation

    ! integer(int32) :: longlonglonglonglonglonglonglonglonglonglong_name_variable1, longlonglonglonglonglonglonglonglonglonglong_name_variable2
    type(vector2) :: vec

    write (*, '(a,x)', advance="no") "input num1"
    read *, num1

    !num2 must be greater than 0.
    get_num2: do
        write (*, '(a,x)', advance="no") "input num2 (>=0)"
        read *, num2

        if (num2 == 0 .and. num2 < 0) then
            cycle get_num2
        end if
        if (num2 > 0) exit get_num2
    end do get_num2

    add = num1 + num2
    sub = num1 - num2
    mul = num1*num2
    div = dble(num1)/dble(num2)
    neg = -num1

    print '(i0,"+",i0,"=",i0)', num1, num2, add
    print '(i0,"-",i0,"=",i0)', num1, num2, sub
    print '(i0,"*",i0,"=",i0)', num1, num2, mul
    print '(i0,"/",i0,"=",g0)', num1, num2, div
    print '("-(",i0,")=",i0)', num1, neg

    vec = vector2(0d0, 0d0)
    vec%x = cos(pi/4d0); vec%y = sin(pi/4d0)
    print *, "hypotenuse=", hypot(vec%x, &
                                  vec%y)
    call clear(vec)

    block
        integer(int32) :: i, j, k, Nx = 1, Ny = 1, Nz = 1
        do k = 1, Nz
        do j = 1, Ny
        do i = 1, Nx
            print *, .not. .true.
        end do
        end do
        end do
    end block

    block
        integer(int32) :: i, j, k, Nx = 1, Ny = 1, Nz = 1
        !&<
        do k = 1, Nz
        do j = 1, Ny
        do i = 1, Nx
            print *, i, &
                     j, &
                     k
        end do
        end do
        end do
        !&>
    end block
end program main
