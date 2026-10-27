module d03_core (clk,
    load_n,
    out,
    rst_n,
    count,
    n_in);
 input clk;
 input load_n;
 output out;
 input rst_n;
 output [6:0] count;
 input [7:0] n_in;

 wire _000_;
 wire _001_;
 wire _002_;
 wire _003_;
 wire _004_;
 wire _005_;
 wire _006_;
 wire _007_;
 wire _008_;
 wire _009_;
 wire _010_;
 wire _011_;
 wire _012_;
 wire _013_;
 wire _014_;
 wire _015_;
 wire _016_;
 wire _017_;
 wire _018_;
 wire _019_;
 wire _020_;
 wire _021_;
 wire _022_;
 wire _023_;
 wire _024_;
 wire _025_;
 wire _026_;
 wire _027_;
 wire _028_;
 wire _029_;
 wire _030_;
 wire _031_;
 wire _032_;
 wire _033_;
 wire _034_;
 wire _035_;
 wire _036_;
 wire _037_;
 wire _038_;
 wire _039_;
 wire _040_;
 wire _041_;
 wire _042_;
 wire _043_;
 wire _044_;
 wire _045_;
 wire _046_;
 wire _047_;
 wire _048_;
 wire _049_;
 wire _050_;
 wire _051_;
 wire _052_;
 wire _053_;
 wire _054_;
 wire _055_;
 wire _056_;
 wire _057_;
 wire _058_;
 wire _059_;
 wire _060_;
 wire _061_;
 wire _062_;
 wire _063_;
 wire _064_;
 wire _065_;
 wire _066_;
 wire _067_;
 wire _068_;
 wire _069_;
 wire _070_;
 wire _071_;
 wire _072_;
 wire _073_;
 wire _074_;
 wire _075_;
 wire _076_;
 wire _077_;
 wire _078_;
 wire _079_;
 wire _080_;
 wire _081_;
 wire _082_;
 wire _083_;
 wire _084_;
 wire _085_;
 wire net11;
 wire net12;
 wire net13;
 wire net14;
 wire net15;
 wire net16;
 wire net17;
 wire net1;
 wire net2;
 wire net3;
 wire net4;
 wire net5;
 wire net6;
 wire net7;
 wire net8;
 wire net9;
 wire \n_reg[0] ;
 wire \n_reg[1] ;
 wire \n_reg[2] ;
 wire \n_reg[3] ;
 wire \n_reg[4] ;
 wire \n_reg[5] ;
 wire \n_reg[6] ;
 wire \n_reg[7] ;
 wire net18;
 wire \phase[0] ;
 wire \phase[1] ;
 wire \phase[2] ;
 wire \phase[3] ;
 wire net10;
 wire clknet_0_clk;
 wire clknet_1_0__leaf_clk;
 wire clknet_1_1__leaf_clk;

 sky130_fd_sc_hd__decap_3 FILLER_0_11 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_14 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_17 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_29 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_32 ();
 sky130_fd_sc_hd__fill_2 FILLER_0_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_0_91 ();
 sky130_fd_sc_hd__fill_1 FILLER_0_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_109 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_112 ();
 sky130_fd_sc_hd__fill_2 FILLER_10_115 ();
 sky130_fd_sc_hd__fill_2 FILLER_10_13 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_42 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_45 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_51 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_10_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_10_88 ();
 sky130_fd_sc_hd__fill_2 FILLER_10_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_11_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_18 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_21 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_24 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_33 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_39 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_42 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_45 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_51 ();
 sky130_fd_sc_hd__fill_2 FILLER_11_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_76 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_79 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_82 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_11_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_108 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_114 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_18 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_21 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_24 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_35 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_48 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_51 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_72 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_12_81 ();
 sky130_fd_sc_hd__fill_2 FILLER_12_85 ();
 sky130_fd_sc_hd__fill_1 FILLER_12_99 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_101 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_104 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_107 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_11 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_110 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_14 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_13_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_80 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_13_86 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_95 ();
 sky130_fd_sc_hd__decap_3 FILLER_13_98 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_106 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_12 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_24 ();
 sky130_fd_sc_hd__fill_1 FILLER_14_27 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_46 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_72 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_85 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_14_9 ();
 sky130_fd_sc_hd__fill_2 FILLER_14_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_116 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_12 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_24 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_33 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_39 ();
 sky130_fd_sc_hd__fill_2 FILLER_15_42 ();
 sky130_fd_sc_hd__fill_1 FILLER_15_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_66 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_69 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_72 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_15_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_102 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_105 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_108 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_114 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_32 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_35 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_16_83 ();
 sky130_fd_sc_hd__fill_2 FILLER_16_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_93 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_96 ();
 sky130_fd_sc_hd__decap_3 FILLER_16_99 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_101 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_104 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_107 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_110 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_20 ();
 sky130_fd_sc_hd__fill_1 FILLER_17_23 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_33 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_39 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_50 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_53 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_60 ();
 sky130_fd_sc_hd__fill_2 FILLER_17_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_82 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_95 ();
 sky130_fd_sc_hd__decap_3 FILLER_17_98 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_114 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_19 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_22 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_25 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_47 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_50 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_53 ();
 sky130_fd_sc_hd__fill_2 FILLER_18_56 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_18_65 ();
 sky130_fd_sc_hd__fill_2 FILLER_18_75 ();
 sky130_fd_sc_hd__fill_1 FILLER_18_85 ();
 sky130_fd_sc_hd__fill_2 FILLER_18_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_102 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_105 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_108 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_12 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_15 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_18 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_21 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_24 ();
 sky130_fd_sc_hd__fill_1 FILLER_19_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_35 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_41 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_44 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_47 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_50 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_53 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_60 ();
 sky130_fd_sc_hd__fill_2 FILLER_19_71 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_93 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_96 ();
 sky130_fd_sc_hd__decap_3 FILLER_19_99 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_109 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_24 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_3 ();
 sky130_fd_sc_hd__fill_2 FILLER_1_30 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_55 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_82 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_1_88 ();
 sky130_fd_sc_hd__fill_1 FILLER_1_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_102 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_105 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_108 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_114 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_34 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_52 ();
 sky130_fd_sc_hd__fill_1 FILLER_2_55 ();
 sky130_fd_sc_hd__fill_2 FILLER_2_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_2_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_107 ();
 sky130_fd_sc_hd__fill_2 FILLER_3_110 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_24 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_52 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_57 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_60 ();
 sky130_fd_sc_hd__fill_1 FILLER_3_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_71 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_74 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_80 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_86 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_89 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_92 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_95 ();
 sky130_fd_sc_hd__decap_3 FILLER_3_98 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_100 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_108 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_17 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_20 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_23 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_26 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_3 ();
 sky130_fd_sc_hd__fill_1 FILLER_4_49 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_70 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_73 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_76 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_79 ();
 sky130_fd_sc_hd__fill_2 FILLER_4_82 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_4_97 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_11 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_19 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_22 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_28 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_31 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_34 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_37 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_40 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_43 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_46 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_49 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_52 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_55 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_60 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_75 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_83 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_86 ();
 sky130_fd_sc_hd__decap_3 FILLER_5_95 ();
 sky130_fd_sc_hd__fill_1 FILLER_5_98 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_108 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_114 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_25 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_32 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_35 ();
 sky130_fd_sc_hd__fill_2 FILLER_6_38 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_50 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_53 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_56 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_59 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_62 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_6_91 ();
 sky130_fd_sc_hd__fill_1 FILLER_6_94 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_103 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_106 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_109 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_7_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_24 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_33 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_36 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_60 ();
 sky130_fd_sc_hd__fill_2 FILLER_7_63 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_78 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_81 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_84 ();
 sky130_fd_sc_hd__decap_3 FILLER_7_87 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_108 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_111 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_114 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_12 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_29 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_32 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_35 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_47 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_6 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_80 ();
 sky130_fd_sc_hd__fill_1 FILLER_8_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_85 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_88 ();
 sky130_fd_sc_hd__decap_3 FILLER_8_9 ();
 sky130_fd_sc_hd__fill_2 FILLER_8_91 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_107 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_110 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_113 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_116 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_12 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_15 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_24 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_27 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_3 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_30 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_33 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_36 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_45 ();
 sky130_fd_sc_hd__fill_2 FILLER_9_54 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_57 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_6 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_60 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_77 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_80 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_83 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_86 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_89 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_9 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_92 ();
 sky130_fd_sc_hd__decap_3 FILLER_9_95 ();
 sky130_fd_sc_hd__fill_1 FILLER_9_98 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Left_20 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_0_Right_0 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Left_30 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_10_Right_10 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Left_31 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_11_Right_11 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Left_32 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_12_Right_12 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Left_33 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_13_Right_13 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_14_Left_34 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_14_Right_14 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_15_Left_35 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_15_Right_15 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_16_Left_36 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_16_Right_16 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_17_Left_37 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_17_Right_17 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_18_Left_38 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_18_Right_18 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_19_Left_39 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_19_Right_19 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Left_21 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_1_Right_1 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Left_22 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_2_Right_2 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Left_23 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_3_Right_3 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Left_24 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_4_Right_4 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Left_25 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_5_Right_5 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Left_26 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_6_Right_6 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Left_27 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_7_Right_7 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Left_28 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_8_Right_8 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Left_29 ();
 sky130_fd_sc_hd__decap_3 PHY_EDGE_ROW_9_Right_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_0_43 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_10_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_11_65 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_12_67 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_68 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_13_69 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_70 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_14_71 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_72 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_15_73 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_74 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_16_75 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_76 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_17_77 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_78 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_18_79 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_80 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_81 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_82 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_19_83 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_1_45 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_2_47 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_3_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_4_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_5_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_6_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_7_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_8_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 TAP_TAPCELL_ROW_9_61 ();
 sky130_fd_sc_hd__inv_2 _086_ (.A(\n_reg[0] ),
    .Y(_045_));
 sky130_fd_sc_hd__or4_2 _087_ (.A(\n_reg[7] ),
    .B(\n_reg[6] ),
    .C(\n_reg[5] ),
    .D(\n_reg[1] ),
    .X(_046_));
 sky130_fd_sc_hd__or4_2 _088_ (.A(\n_reg[4] ),
    .B(\n_reg[3] ),
    .C(\n_reg[2] ),
    .D(_046_),
    .X(_047_));
 sky130_fd_sc_hd__or2_2 _089_ (.A(_045_),
    .B(_047_),
    .X(_048_));
 sky130_fd_sc_hd__o21a_2 _090_ (.A1(_003_),
    .A2(\phase[0] ),
    .B1(_048_),
    .X(net11));
 sky130_fd_sc_hd__o21a_2 _091_ (.A1(_003_),
    .A2(\phase[1] ),
    .B1(_048_),
    .X(net12));
 sky130_fd_sc_hd__o21a_2 _092_ (.A1(_003_),
    .A2(\phase[2] ),
    .B1(_048_),
    .X(net13));
 sky130_fd_sc_hd__o21a_2 _093_ (.A1(_003_),
    .A2(\phase[3] ),
    .B1(_048_),
    .X(net14));
 sky130_fd_sc_hd__o21a_2 _094_ (.A1(_003_),
    .A2(_000_),
    .B1(_048_),
    .X(net15));
 sky130_fd_sc_hd__o21a_2 _095_ (.A1(_003_),
    .A2(_001_),
    .B1(_048_),
    .X(net16));
 sky130_fd_sc_hd__o21a_2 _096_ (.A1(_003_),
    .A2(_002_),
    .B1(_048_),
    .X(net17));
 sky130_fd_sc_hd__and2b_2 _097_ (.A_N(net1),
    .B(net10),
    .X(_049_));
 sky130_fd_sc_hd__nand2b_2 _098_ (.A_N(net1),
    .B(net10),
    .Y(_050_));
 sky130_fd_sc_hd__a21oi_2 _099_ (.A1(\n_reg[0] ),
    .A2(net18),
    .B1(\n_reg[1] ),
    .Y(_051_));
 sky130_fd_sc_hd__and3_2 _100_ (.A(\n_reg[1] ),
    .B(\n_reg[0] ),
    .C(net18),
    .X(_052_));
 sky130_fd_sc_hd__or2_2 _101_ (.A(_051_),
    .B(_052_),
    .X(_053_));
 sky130_fd_sc_hd__nand2_2 _102_ (.A(_047_),
    .B(_053_),
    .Y(_054_));
 sky130_fd_sc_hd__and4_2 _103_ (.A(\n_reg[2] ),
    .B(\n_reg[1] ),
    .C(\n_reg[0] ),
    .D(net18),
    .X(_055_));
 sky130_fd_sc_hd__xnor2_2 _104_ (.A(\n_reg[2] ),
    .B(_052_),
    .Y(_056_));
 sky130_fd_sc_hd__nand2_2 _105_ (.A(\n_reg[3] ),
    .B(_055_),
    .Y(_057_));
 sky130_fd_sc_hd__xnor2_2 _106_ (.A(\n_reg[3] ),
    .B(_055_),
    .Y(_058_));
 sky130_fd_sc_hd__and4_2 _107_ (.A(_047_),
    .B(_053_),
    .C(_056_),
    .D(_058_),
    .X(_059_));
 sky130_fd_sc_hd__xor2_2 _108_ (.A(\n_reg[4] ),
    .B(_057_),
    .X(_060_));
 sky130_fd_sc_hd__and4_2 _109_ (.A(\n_reg[5] ),
    .B(\n_reg[4] ),
    .C(\n_reg[3] ),
    .D(_055_),
    .X(_061_));
 sky130_fd_sc_hd__a31o_2 _110_ (.A1(\n_reg[4] ),
    .A2(\n_reg[3] ),
    .A3(_055_),
    .B1(\n_reg[5] ),
    .X(_062_));
 sky130_fd_sc_hd__nand2b_2 _111_ (.A_N(_061_),
    .B(_062_),
    .Y(_063_));
 sky130_fd_sc_hd__nand3_2 _112_ (.A(_059_),
    .B(_060_),
    .C(_063_),
    .Y(_064_));
 sky130_fd_sc_hd__nand2_2 _113_ (.A(\n_reg[6] ),
    .B(_061_),
    .Y(_065_));
 sky130_fd_sc_hd__or2_2 _114_ (.A(\n_reg[6] ),
    .B(_061_),
    .X(_066_));
 sky130_fd_sc_hd__nand2_2 _115_ (.A(_065_),
    .B(_066_),
    .Y(_067_));
 sky130_fd_sc_hd__and2b_2 _116_ (.A_N(_064_),
    .B(_067_),
    .X(_068_));
 sky130_fd_sc_hd__xnor2_2 _117_ (.A(_064_),
    .B(_067_),
    .Y(_069_));
 sky130_fd_sc_hd__xnor2_2 _118_ (.A(_001_),
    .B(_069_),
    .Y(_070_));
 sky130_fd_sc_hd__a21o_2 _119_ (.A1(_059_),
    .A2(_060_),
    .B1(_063_),
    .X(_071_));
 sky130_fd_sc_hd__a21bo_2 _120_ (.A1(_064_),
    .A2(_071_),
    .B1_N(_000_),
    .X(_072_));
 sky130_fd_sc_hd__nand3b_2 _121_ (.A_N(_000_),
    .B(_064_),
    .C(_071_),
    .Y(_073_));
 sky130_fd_sc_hd__xnor2_2 _122_ (.A(\n_reg[7] ),
    .B(_002_),
    .Y(_074_));
 sky130_fd_sc_hd__xnor2_2 _123_ (.A(_065_),
    .B(_074_),
    .Y(_075_));
 sky130_fd_sc_hd__xnor2_2 _124_ (.A(_068_),
    .B(_075_),
    .Y(_076_));
 sky130_fd_sc_hd__a31oi_2 _125_ (.A1(_047_),
    .A2(_053_),
    .A3(_056_),
    .B1(_058_),
    .Y(_077_));
 sky130_fd_sc_hd__o21ba_2 _126_ (.A1(_059_),
    .A2(_077_),
    .B1_N(\phase[2] ),
    .X(_078_));
 sky130_fd_sc_hd__nor3b_2 _127_ (.A(_059_),
    .B(_077_),
    .C_N(\phase[2] ),
    .Y(_079_));
 sky130_fd_sc_hd__xnor2_2 _128_ (.A(_054_),
    .B(_056_),
    .Y(_080_));
 sky130_fd_sc_hd__a21oi_2 _129_ (.A1(\phase[0] ),
    .A2(_054_),
    .B1(_003_),
    .Y(_081_));
 sky130_fd_sc_hd__o221ai_2 _130_ (.A1(\phase[0] ),
    .A2(_054_),
    .B1(_080_),
    .B2(\phase[1] ),
    .C1(_081_),
    .Y(_082_));
 sky130_fd_sc_hd__a211o_2 _131_ (.A1(\phase[1] ),
    .A2(_080_),
    .B1(_079_),
    .C1(_078_),
    .X(_083_));
 sky130_fd_sc_hd__xor2_2 _132_ (.A(_059_),
    .B(_060_),
    .X(_084_));
 sky130_fd_sc_hd__xnor2_2 _133_ (.A(\phase[3] ),
    .B(_084_),
    .Y(_085_));
 sky130_fd_sc_hd__a2111o_2 _134_ (.A1(_072_),
    .A2(_073_),
    .B1(_082_),
    .C1(_083_),
    .D1(_085_),
    .X(_021_));
 sky130_fd_sc_hd__or4_2 _135_ (.A(net18),
    .B(_070_),
    .C(_076_),
    .D(_021_),
    .X(_022_));
 sky130_fd_sc_hd__o31ai_2 _136_ (.A1(_070_),
    .A2(_076_),
    .A3(_021_),
    .B1(net18),
    .Y(_023_));
 sky130_fd_sc_hd__a31oi_2 _137_ (.A1(_048_),
    .A2(_022_),
    .A3(_023_),
    .B1(_050_),
    .Y(_004_));
 sky130_fd_sc_hd__or4_2 _138_ (.A(net3),
    .B(net5),
    .C(net4),
    .D(net7),
    .X(_024_));
 sky130_fd_sc_hd__or4_2 _139_ (.A(net6),
    .B(net9),
    .C(net8),
    .D(_024_),
    .X(_025_));
 sky130_fd_sc_hd__and2_2 _140_ (.A(net1),
    .B(net10),
    .X(_026_));
 sky130_fd_sc_hd__nand2_2 _141_ (.A(_025_),
    .B(_026_),
    .Y(_027_));
 sky130_fd_sc_hd__o22a_2 _142_ (.A1(\n_reg[0] ),
    .A2(_050_),
    .B1(_027_),
    .B2(net2),
    .X(_005_));
 sky130_fd_sc_hd__a22o_2 _143_ (.A1(\n_reg[1] ),
    .A2(_049_),
    .B1(_026_),
    .B2(net3),
    .X(_006_));
 sky130_fd_sc_hd__a22o_2 _144_ (.A1(\n_reg[2] ),
    .A2(_049_),
    .B1(_026_),
    .B2(net4),
    .X(_007_));
 sky130_fd_sc_hd__a22o_2 _145_ (.A1(\n_reg[3] ),
    .A2(_049_),
    .B1(_026_),
    .B2(net5),
    .X(_008_));
 sky130_fd_sc_hd__a22o_2 _146_ (.A1(\n_reg[4] ),
    .A2(_049_),
    .B1(_026_),
    .B2(net6),
    .X(_009_));
 sky130_fd_sc_hd__a22o_2 _147_ (.A1(\n_reg[5] ),
    .A2(_049_),
    .B1(_026_),
    .B2(net7),
    .X(_010_));
 sky130_fd_sc_hd__a22o_2 _148_ (.A1(\n_reg[6] ),
    .A2(_049_),
    .B1(_026_),
    .B2(net8),
    .X(_011_));
 sky130_fd_sc_hd__a22o_2 _149_ (.A1(\n_reg[7] ),
    .A2(_049_),
    .B1(_026_),
    .B2(net9),
    .X(_012_));
 sky130_fd_sc_hd__o31a_2 _150_ (.A1(_070_),
    .A2(_076_),
    .A3(_021_),
    .B1(_049_),
    .X(_028_));
 sky130_fd_sc_hd__and3b_2 _151_ (.A_N(\phase[0] ),
    .B(_048_),
    .C(_028_),
    .X(_013_));
 sky130_fd_sc_hd__nand2_2 _152_ (.A(\phase[0] ),
    .B(\phase[1] ),
    .Y(_029_));
 sky130_fd_sc_hd__or2_2 _153_ (.A(\phase[0] ),
    .B(\phase[1] ),
    .X(_030_));
 sky130_fd_sc_hd__and4_2 _154_ (.A(_048_),
    .B(_028_),
    .C(_029_),
    .D(_030_),
    .X(_014_));
 sky130_fd_sc_hd__and3_2 _155_ (.A(\phase[0] ),
    .B(\phase[1] ),
    .C(\phase[2] ),
    .X(_031_));
 sky130_fd_sc_hd__inv_2 _156_ (.A(_031_),
    .Y(_032_));
 sky130_fd_sc_hd__a21o_2 _157_ (.A1(\phase[0] ),
    .A2(\phase[1] ),
    .B1(\phase[2] ),
    .X(_033_));
 sky130_fd_sc_hd__and4_2 _158_ (.A(_048_),
    .B(_028_),
    .C(_032_),
    .D(_033_),
    .X(_015_));
 sky130_fd_sc_hd__and2_2 _159_ (.A(\phase[3] ),
    .B(_031_),
    .X(_034_));
 sky130_fd_sc_hd__inv_2 _160_ (.A(_034_),
    .Y(_035_));
 sky130_fd_sc_hd__or2_2 _161_ (.A(\phase[3] ),
    .B(_031_),
    .X(_036_));
 sky130_fd_sc_hd__and4_2 _162_ (.A(_048_),
    .B(_028_),
    .C(_035_),
    .D(_036_),
    .X(_016_));
 sky130_fd_sc_hd__nand2_2 _163_ (.A(_000_),
    .B(_034_),
    .Y(_037_));
 sky130_fd_sc_hd__or2_2 _164_ (.A(_000_),
    .B(_034_),
    .X(_038_));
 sky130_fd_sc_hd__and4_2 _165_ (.A(_048_),
    .B(_028_),
    .C(_037_),
    .D(_038_),
    .X(_017_));
 sky130_fd_sc_hd__and3_2 _166_ (.A(_000_),
    .B(_001_),
    .C(_034_),
    .X(_039_));
 sky130_fd_sc_hd__inv_2 _167_ (.A(_039_),
    .Y(_040_));
 sky130_fd_sc_hd__a31o_2 _168_ (.A1(\phase[3] ),
    .A2(_000_),
    .A3(_031_),
    .B1(_001_),
    .X(_041_));
 sky130_fd_sc_hd__and4_2 _169_ (.A(_048_),
    .B(_028_),
    .C(_040_),
    .D(_041_),
    .X(_018_));
 sky130_fd_sc_hd__nand2_2 _170_ (.A(_002_),
    .B(_039_),
    .Y(_042_));
 sky130_fd_sc_hd__or2_2 _171_ (.A(_002_),
    .B(_039_),
    .X(_043_));
 sky130_fd_sc_hd__and4_2 _172_ (.A(_048_),
    .B(_028_),
    .C(_042_),
    .D(_043_),
    .X(_019_));
 sky130_fd_sc_hd__xnor2_2 _173_ (.A(_003_),
    .B(_042_),
    .Y(_044_));
 sky130_fd_sc_hd__and3_2 _174_ (.A(_048_),
    .B(_028_),
    .C(_044_),
    .X(_020_));
 sky130_fd_sc_hd__dfxtp_2 _175_ (.CLK(clknet_1_0__leaf_clk),
    .D(_004_),
    .Q(net18));
 sky130_fd_sc_hd__dfxtp_2 _176_ (.CLK(clknet_1_0__leaf_clk),
    .D(_005_),
    .Q(\n_reg[0] ));
 sky130_fd_sc_hd__dfxtp_2 _177_ (.CLK(clknet_1_0__leaf_clk),
    .D(_006_),
    .Q(\n_reg[1] ));
 sky130_fd_sc_hd__dfxtp_2 _178_ (.CLK(clknet_1_0__leaf_clk),
    .D(_007_),
    .Q(\n_reg[2] ));
 sky130_fd_sc_hd__dfxtp_2 _179_ (.CLK(clknet_1_0__leaf_clk),
    .D(_008_),
    .Q(\n_reg[3] ));
 sky130_fd_sc_hd__dfxtp_2 _180_ (.CLK(clknet_1_0__leaf_clk),
    .D(_009_),
    .Q(\n_reg[4] ));
 sky130_fd_sc_hd__dfxtp_2 _181_ (.CLK(clknet_1_0__leaf_clk),
    .D(_010_),
    .Q(\n_reg[5] ));
 sky130_fd_sc_hd__dfxtp_2 _182_ (.CLK(clknet_1_0__leaf_clk),
    .D(_011_),
    .Q(\n_reg[6] ));
 sky130_fd_sc_hd__dfxtp_2 _183_ (.CLK(clknet_1_0__leaf_clk),
    .D(_012_),
    .Q(\n_reg[7] ));
 sky130_fd_sc_hd__dfxtp_2 _184_ (.CLK(clknet_1_1__leaf_clk),
    .D(_013_),
    .Q(\phase[0] ));
 sky130_fd_sc_hd__dfxtp_2 _185_ (.CLK(clknet_1_1__leaf_clk),
    .D(_014_),
    .Q(\phase[1] ));
 sky130_fd_sc_hd__dfxtp_2 _186_ (.CLK(clknet_1_1__leaf_clk),
    .D(_015_),
    .Q(\phase[2] ));
 sky130_fd_sc_hd__dfxtp_2 _187_ (.CLK(clknet_1_1__leaf_clk),
    .D(_016_),
    .Q(\phase[3] ));
 sky130_fd_sc_hd__dfxtp_2 _188_ (.CLK(clknet_1_1__leaf_clk),
    .D(_017_),
    .Q(_000_));
 sky130_fd_sc_hd__dfxtp_2 _189_ (.CLK(clknet_1_1__leaf_clk),
    .D(_018_),
    .Q(_001_));
 sky130_fd_sc_hd__dfxtp_2 _190_ (.CLK(clknet_1_1__leaf_clk),
    .D(_019_),
    .Q(_002_));
 sky130_fd_sc_hd__dfxtp_2 _191_ (.CLK(clknet_1_1__leaf_clk),
    .D(_020_),
    .Q(_003_));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_0_clk (.A(clk),
    .X(clknet_0_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_0__f_clk (.A(clknet_0_clk),
    .X(clknet_1_0__leaf_clk));
 sky130_fd_sc_hd__clkbuf_16 clkbuf_1_1__f_clk (.A(clknet_0_clk),
    .X(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__clkbuf_4 clkload0 (.A(clknet_1_1__leaf_clk));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input1 (.A(load_n),
    .X(net1));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input10 (.A(rst_n),
    .X(net10));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input2 (.A(n_in[0]),
    .X(net2));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input3 (.A(n_in[1]),
    .X(net3));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input4 (.A(n_in[2]),
    .X(net4));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input5 (.A(n_in[3]),
    .X(net5));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input6 (.A(n_in[4]),
    .X(net6));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input7 (.A(n_in[5]),
    .X(net7));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input8 (.A(n_in[6]),
    .X(net8));
 sky130_fd_sc_hd__clkdlybuf4s25_1 input9 (.A(n_in[7]),
    .X(net9));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output11 (.A(net11),
    .X(count[0]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output12 (.A(net12),
    .X(count[1]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output13 (.A(net13),
    .X(count[2]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output14 (.A(net14),
    .X(count[3]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output15 (.A(net15),
    .X(count[4]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output16 (.A(net16),
    .X(count[5]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output17 (.A(net17),
    .X(count[6]));
 sky130_fd_sc_hd__clkdlybuf4s25_1 output18 (.A(net18),
    .X(out));
endmodule
