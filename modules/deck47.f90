!-*- mode: f90; indent-tabs-mode: nil; coding: utf-8; show-trailing-whitespace: t -*-

!
! file deck47.f90
!

module c29b01
  implicit none
  !common /c29b01/ karray(3)
  integer(4) :: karray(3)
  ! equivalences friend zone.
  ! from over 47
  integer(4) :: itg(1)
  real(8) :: rtg(1)
  complex(16) :: ctg(1)
  equivalence (karray(1), itg(1), rtg(1), ctg(1))
end module c29b01

!
! end of file deck47.f90
!
