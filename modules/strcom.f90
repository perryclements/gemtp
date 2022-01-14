!-*- Mode: f90; indent-tabs-mode: nil; coding: utf-8; show-trailing-whitespace: t -*-

!
! file strcom.f90
!

!
! subroutine to_upper.
!

module strcom
  implicit none

  interface pack
     module procedure packa1, packch
  end interface pack

contains

  function to_upper (strIn) result(strOut)
    ! Adapted from http://www.star.le.ac.uk/~cgp/fortran.html (25 May 2012)
    ! Original author: Clive Page
    implicit none
    character(len = *), intent(in) :: strIn
    character(len = len(strIn)) :: strOut
    integer(4) :: i, j
    !
    do i = 1, len (strIn)
       j = iachar (strIn(i : i))
       if (j >= iachar ("a") .and. j <= iachar ("z")) then
          strOut(i : i) = achar (iachar (strIn(i : i)) - iachar ("a") + iachar ("A"))
       else
          strOut(i : i) = strIn(i : i)
       end if
    end do
  end function to_upper

  function to_lower (strIn) result(strOut)
    implicit none
    character(len = *), intent(in) :: strIn
    character(len = len(strIn)) :: strOut
    integer(4) :: i, j
    !
    do i = 1, len (strIn)
       j = iachar (strIn(i : i))
       if (j >= iachar ("A") .and. j <= iachar ("Z")) then
          strOut(i : i) = achar (iachar (strIn(i : i)) - iachar ("A") + iachar ("a"))
       else
          strOut(i : i) = strIn(i : i)
       end if
    end do
  end function to_lower

  !
  ! subroutine str2int.
  !

  subroutine str2int (str, int, stat)
    implicit none
    character(len = *), intent(in) :: str
    integer(4), intent(out) :: int
    integer(4), intent(out) :: stat
    !
    read (unit = str, fmt = 10, iostat = stat) int
10  format (i8)
  end subroutine str2int

  !
  ! subroutine strip.
  !

  subroutine strip (s, c)
    implicit none
    character(*), intent(inout) :: s
    character, intent(in) :: c
    !
    integer(4) :: i, j
    character, pointer :: temp(:)
    !
    allocate (temp(len (s)))
    if (associated (temp)) then
       j = 1
       do i = 1, len (s)
          if (s(i : i) .ne. c) then
             temp(j : j) = s(i : i)
             j = j + 1
          end if
       end do
       do i = 1, j - 1
          s(i : i) = temp(i)
       end do
       deallocate (temp)
       nullify (temp)
    end if
  end subroutine strip

  !
  ! subroutine packa1.
  !

  subroutine packa1 (from, to, kk)
    implicit none
    !     System-dependent EMTP module  'packa1'  for  VAX-11/780.
    !     Argument  'from'  contains  a1  information which is to be stored
    !     in character position  kk  of argument  'to' .
    !     For all EMTP usage,  1st 2 arguments must be vectors.
    !     logical*1 from(1), to(6)
    character(8), intent(in) :: from
    character(8), intent(out) :: to
    integer(4), intent(in) :: kk
    !
    to(kk : kk) = from(1 : 1)
    return
  end subroutine packa1

  !
  ! subroutine packch.
  !

  subroutine packch (from, to, k4or6, nchbeg, nword)
    implicit none
    !
    !     This module performs the system-dependent function of packing bcd
    !     characters from  a4  or  a6  words together so as to form a
    !     contiguous string of characters without extra blank fill.   For
    !     example, cdc has a 60-bit word which stores 10 bcd characters (6
    !     bits to a character).   With plot alphanumeric text read under  a6
    !     format control, the right-most four characters of such words will
    !     be blank-filled by the system.   IBM's eight characters in an
    !     eight-byte word pose an analogous problem.   Since the  calcomp
    !     plotting subroutine calls which appear in
    !     the calling module require contiguous character strings, output
    !     text must be compressed so as to remove the word-length-dependent
    !     blank fill.   The present subroutine is called by the plotting
    !     code to perform this function.   Meaning of the subroutine
    !     arguments is as follows ......
    !      nword ----- the number of words which are to have their bcd
    !                  characters extracted, and packed into  a character
    !                  string.   this is a positive integer.
    !      from(1)  ----- the first of  'nword'  words  whose bcd contents
    !                     are to be packed.
    !      k4or6  ----- equal to either  4  or  6 ,  whichever is the number
    !                   of characters of bcd information which is stored in
    !                   the words   (from(i), i=1, nword) .
    !      to(1)  ----- the active bcd characters of   (from(i), i=1, nword)
    !                   are to be packed as a contiguous string of
    !                   characters beginning with character position
    !                   'nchbeg'  of word  to(1) .
    !      nchbeg  -----  the character position of word  to(1)  where the
    !                     contiguous string of bcd characters is to begin.
    !                     normally  'nchbeg'  is between  1  and  10 ,
    !                     although larger positive values are allowed.
    !                     for example, a value of  27  means that the cdc
    !                     character insertion begins in position  7  of
    !                     word  to(3) .
    character(8), intent(in) :: from(nword)
    character(8), intent(out) :: to(nword)
    integer(4), intent(in) :: k4or6, nchbeg, nword
    integer(4) :: i_char, iword, j_char, k_char
    !
    select case (k4or6)
    case (4, 6)
       i_char = nchbeg
       do iword = 1, nword
          do k_char = 1, k4or6
             j_char = (iword - 1) * 8 + k_char
             to(i_char) = from(j_char)
             i_char = i_char + 1
          end do
       end do

    case default
       call stoptp
    end select
    return
  end subroutine packch

end module strcom
