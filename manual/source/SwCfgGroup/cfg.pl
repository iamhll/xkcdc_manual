#!/usr/bin/perl
#-------------------------------------------------------------------------------
    #
    #  Filename       : cfg.pl
    #  Author         : Huang Leilei
    #  Status         : phase 003
    #  Reset          : 2021-10-15
    #  Description    : script to generate cfg.*
    #
#-------------------------------------------------------------------------------

#*** OPTION ********************************************************************
    #use 5.010;
    use utf8;
    use strict;


#*** VARIABLES *****************************************************************
    my $fptInp           ;
    my $fptOut           ;
    my $num              ;
    my $sizStrDomain     ;
    my $sizStrLevel      ;
    my $sizStrNameCur    ;
    my $sizStrNameCurKey ;
    my $sizStrNameCurVar ;
    my $sizStrSize       ;
    my $sizStrKeyShort   ;
    my $sizStrType       ;
    my $sizStrDatMin     ;
    my $sizStrDatMax     ;
    my $sizStrDatPrc     ;
    my $sizStrDatDef     ;
    my $sizStrDescription;
    my $sizStrFlgH265Main;
    my $sizStrFlgH265Low ;
    my $sizStrFlgH264    ;

    my $domainOld        ;
    my $flgOpened        ;

    my @domain     ;
    my @level      ;
    my @nameCur    ;
    my @size       ;
    my @keyShort   ;
    my @type       ;
    my @datMin     ;
    my @datMax     ;
    my @datPrc     ;
    my @datDef     ;
    my @description;
    my @flgH265Main;
    my @flgH265Low ;
    my @flgH264    ;


#*** MAIN BODY *****************************************************************
#--- GREP INFO -------------------------
    # open file
    open $fptInp, "< cfg.csv";

    # grep
    $num = 0;
    while(<$fptInp>) {
        chomp;
        /(?<domain>.*),(?<nameCur>.*),(?<level>.*),(?<size>.*),(?<keyShort>.*),(?<type>.*),(?<datMin>.*),(?<datMax>.*),(?<datPrc>.*),(?<datDef>.*),(?<description>.*),(?<flgH265Main>.*),(?<flgH265Low>.*),(?<flgH264>.*)/;
        $domain     [$num] = $+{domain     };
        $nameCur    [$num] = $+{nameCur    };
        $level      [$num] = $+{level      };
        $size       [$num] = $+{size       };
        $keyShort   [$num] = $+{keyShort   };
        $type       [$num] = $+{type       };
        $datMin     [$num] = $+{datMin     };
        $datMax     [$num] = $+{datMax     };
        $datPrc     [$num] = $+{datPrc     };
        $datDef     [$num] = $+{datDef     };
        $description[$num] = $+{description};
        $flgH265Main[$num] = $+{flgH265Main};
        $flgH265Low [$num] = $+{flgH265Low };
        $flgH264    [$num] = $+{flgH264    };
        $num = $num + 1;
    }


#--- GET LENGTH ------------------------
    $sizStrDomain      = 0;
    $sizStrNameCur     = 0;
    $sizStrLevel       = 0;
    $sizStrNameCurKey  = 0;
    $sizStrNameCurVar  = 0;
    $sizStrSize        = 0;
    $sizStrKeyShort    = 0;
    $sizStrType        = 0;
    $sizStrDatMin      = 0;
    $sizStrDatMax      = 0;
    $sizStrDatPrc      = 0;
    $sizStrDatDef      = 0;
    $sizStrDescription = 0;
    $sizStrFlgH265Main = 0;
    $sizStrFlgH265Low  = 0;
    $sizStrFlgH264     = 0;
    foreach my $idx (0 .. $num - 1) {
        if ($domain[$idx] !~ m/removed/ && $domain[$idx] !~ m/temporary/) {
            if (length($domain     [$idx]) > $sizStrDomain     ) {
                $sizStrDomain      = length($domain     [$idx]);
            }
            if (length($nameCur    [$idx]) > $sizStrNameCur    ) {
                $sizStrNameCur     = length($nameCur    [$idx]);
            }
            if (length($level      [$idx]) > $sizStrLevel      ) {
                $sizStrLevel       = length($level    [$idx]);
            }

            my $sizStrNameCurKeyTmp;
            if ($size[$idx] == 1) {
                $sizStrNameCurKeyTmp = length($nameCur[$idx]);
            }
            elsif ($size[$idx] !~ /x/) {
                $sizStrNameCurKeyTmp = length($nameCur[$idx]) + 2;
            }
            else {
                $sizStrNameCurKeyTmp = length($nameCur[$idx]) + 4;
            }
            if ($sizStrNameCurKeyTmp > $sizStrNameCurKey) {
                $sizStrNameCurKey = $sizStrNameCurKeyTmp;
            }

            my $sizStrNameCurVarTmp;
            if ($size[$idx] == 1) {
                $sizStrNameCurVarTmp = length($nameCur[$idx]);
            }
            elsif ($size[$idx] !~ /x/) {
                $sizStrNameCurVarTmp = length($nameCur[$idx]) + 3;
            }
            else {
                $sizStrNameCurVarTmp = length($nameCur[$idx]) + 6;
            }
            if ($sizStrNameCurVarTmp > $sizStrNameCurVar) {
                $sizStrNameCurVar = $sizStrNameCurVarTmp;
            }

            if (length($nameCur    [$idx]) > $sizStrNameCur    ) {
                $sizStrNameCur     = length($nameCur    [$idx]);
            }
            if (length($size       [$idx]) > $sizStrSize       ) {
                $sizStrSize        = length($size       [$idx]);
            }
            if (length($keyShort   [$idx]) > $sizStrKeyShort   ) {
                $sizStrKeyShort    = length($keyShort   [$idx]);
            }
            if (length($type       [$idx]) > $sizStrType       ) {
                $sizStrType        = length($type       [$idx]);
            }
            if (length($datMin     [$idx]) > $sizStrDatMin     ) {
                $sizStrDatMin      = length($datMin     [$idx]);
            }
            if (length($datMax     [$idx]) > $sizStrDatMax     ) {
                $sizStrDatMax      = length($datMax     [$idx]);
            }
            if (length($datPrc     [$idx]) > $sizStrDatPrc     ) {
                $sizStrDatPrc      = length($datPrc     [$idx]);
            }
            if (length($datDef     [$idx]) > $sizStrDatDef     ) {
                $sizStrDatDef      = length($datDef     [$idx]);
            }
            if (length($description[$idx]) > $sizStrDescription) {
                $sizStrDescription = length($description[$idx]);
            }
            if (length($flgH265Main[$idx]) > $sizStrFlgH265Main) {
                $sizStrFlgH265Main = length($flgH265Main[$idx]);
            }
            if (length($flgH265Low [$idx]) > $sizStrFlgH265Low ) {
                $sizStrFlgH265Low  = length($flgH265Low [$idx]);
            }
            if (length($flgH264    [$idx]) > $sizStrFlgH264    ) {
                $sizStrFlgH264     = length($flgH264    [$idx]);
            }
        }
    }


#--- DISP INFO -------------------------
    my $strDsp = " | %03d "
        . "| %-${sizStrDomain}s "
        . "| %-${sizStrNameCur}s "
        . "| %-${sizStrSize}s "
        . "| %-${sizStrKeyShort}s "
        . "| %-${sizStrType}s "
        . "| %-${sizStrDatMin}s "
        . "| %-${sizStrDatMax}s "
        . "| %-${sizStrDatPrc}s "
        . "|\n"
    ;
    foreach my $idx (0 .. $num - 1) {
        if ($domain[$idx] !~ m/removed/ && $domain[$idx] !~ m/temporary/) {
            printf $strDsp
                ,$idx
                ,$domain     [$idx]
                ,$nameCur    [$idx]
                ,$size       [$idx]
                ,$keyShort   [$idx]
                ,$type       [$idx]
                ,$datMin     [$idx]
                ,$datMax     [$idx]
                ,$datPrc     [$idx]
                ,$datDef     [$idx]
            ;
        }
    }


#--- UPDATE cfg.rst --------------------
    {
        # string
        my $lineTable = ("=" x ($sizStrDomain + 2))
            . " " . ("=" x ($sizStrNameCur     + 2))
            . " " . ("=" x ($sizStrSize        + 2))
            . " " . ("=" x ($sizStrKeyShort    + 2))
            . " " . ("=" x ($sizStrType        + 2))
            . " " . ("=" x ($sizStrDatMin      + 2))
            . " " . ("=" x ($sizStrDatMax      + 2))
            . " " . ("=" x ($sizStrDatPrc      + 2))
            . " " . ("=" x ($sizStrDatDef      + 2))
            . " " . ("=" x ($sizStrDescription + 2))
            . " " . ("=" x ($sizStrFlgH265Main + 2))
            . " " . ("=" x ($sizStrFlgH265Low  + 2))
            . " " . ("=" x ($sizStrFlgH264     + 2))
            . "\n"
        ;
        my $strDsp = " %-${sizStrDomain}s "
            . "  %-${sizStrNameCur}s "
            . "  %-${sizStrSize}s "
            . "  %-${sizStrKeyShort}s "
            . "  %-${sizStrType}s "
            . "  %-${sizStrDatMin}s "
            . "  %-${sizStrDatMax}s "
            . "  %-${sizStrDatPrc}s "
            . "  %-${sizStrDatDef}s "
            . "  %-${sizStrDescription}s "
            . "  %-${sizStrFlgH265Main}s "
            . "  %-${sizStrFlgH265Low}s "
            . "  %s"
            . "\n"
        ;

        # main loop
        $domainOld = -1;
        $flgOpened = 0;
        foreach my $idx (0 .. $num - 1) {
            if ($domain[$idx] !~ m/domain/ && $domain[$idx] !~ m/virtual/ && $domain[$idx] !~ m/changeable/ && $domain[$idx] !~ m/derived/) {
                if ($domain[$idx] !~ $domainOld) {
                    if ($flgOpened) {
                        # tail
                        print $fptOut $lineTable;

                        # close file
                        close $fptOut;
                    }

                    # open file
                    open $fptOut, "> $domain[$idx]_sub.rst";
                    $flgOpened = 1;

                    # header
                    print $fptOut $lineTable;
                    my $description = $description[0];
                    $description =~ s/\"//g;
                    printf $fptOut $strDsp
                        ,$domain     [0]
                        ,$nameCur    [0]
                        ,$size       [0]
                        ,$keyShort   [0]
                        ,$type       [0]
                        ,$datMin     [0]
                        ,$datMax     [0]
                        ,$datPrc     [0]
                        ,$datDef     [0]
                        ,$description
                        ,$flgH265Main[0]
                        ,$flgH265Low [0]
                        ,$flgH264    [0]
                    ;
                    print $fptOut $lineTable;
                }

                # content
                my $description = $description[$idx];
                $description =~ s/\"//g;
                printf $fptOut $strDsp
                    ,$domain     [$idx]
                    ,$nameCur    [$idx]
                    ,$size       [$idx]
                    ,$keyShort   [$idx]
                    ,$type       [$idx]
                    ,$datMin     [$idx]
                    ,$datMax     [$idx]
                    ,$datPrc     [$idx]
                    ,$datDef     [$idx]
                    ,$description
                    ,$flgH265Main[$idx]
                    ,$flgH265Low [$idx]
                    ,$flgH264    [$idx]
                ;

                # update
                $domainOld = $domain[$idx];
            }
        }
        print $fptOut $lineTable;
    }
