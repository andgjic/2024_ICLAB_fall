/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : T-2022.03
// Date      : Thu Dec  5 00:16:32 2024
/////////////////////////////////////////////////////////////


module TETRIS ( rst_n, clk, in_valid, tetrominoes, position, tetris_valid, 
        score_valid, fail, score, tetris );
  input [2:0] tetrominoes;
  input [2:0] position;
  output [3:0] score;
  output [71:0] tetris;
  input rst_n, clk, in_valid;
  output tetris_valid, score_valid, fail;
  wire   next_state_0_, bottom_2__0_, bottom_1__0_, bottom_0__0_, N700, N701,
         N702, N703, N704, N705, N706, N707, N708, N709, N710, N711, N712,
         N713, N714, N715, N716, N717, N718, N719, N720, N721, N722, N723,
         map_f_12__5_, map_f_12__4_, map_f_12__3_, map_f_12__2_, map_f_12__1_,
         map_f_12__0_, map_f_11__5_, map_f_11__4_, map_f_11__3_, map_f_11__2_,
         map_f_11__1_, map_f_11__0_, map_f_10__5_, map_f_10__4_, map_f_10__3_,
         map_f_10__2_, map_f_10__1_, map_f_10__0_, map_f_9__5_, map_f_9__4_,
         map_f_9__3_, map_f_9__2_, map_f_9__1_, map_f_9__0_, map_f_8__5_,
         map_f_8__4_, map_f_8__3_, map_f_8__2_, map_f_8__1_, map_f_8__0_,
         map_f_7__5_, map_f_7__4_, map_f_7__3_, map_f_7__2_, map_f_7__1_,
         map_f_7__0_, map_f_6__5_, map_f_6__4_, map_f_6__3_, map_f_6__2_,
         map_f_6__1_, map_f_6__0_, map_f_5__5_, map_f_5__4_, map_f_5__3_,
         map_f_5__2_, map_f_5__1_, map_f_5__0_, map_f_4__5_, map_f_4__4_,
         map_f_4__3_, map_f_4__2_, map_f_4__1_, map_f_4__0_, map_f_3__5_,
         map_f_3__4_, map_f_3__3_, map_f_3__2_, map_f_3__1_, map_f_3__0_,
         map_f_2__5_, map_f_2__4_, map_f_2__3_, map_f_2__2_, map_f_2__1_,
         map_f_2__0_, map_f_1__5_, map_f_1__4_, map_f_1__3_, map_f_1__2_,
         map_f_1__1_, map_f_1__0_, map_f_0__5_, map_f_0__4_, map_f_0__3_,
         map_f_0__2_, map_f_0__1_, map_f_0__0_, N964, n641, n642, n643, n644,
         n645, n646, n647, n648, n649, n650, n651, n652, n653, n654, n655,
         n656, n657, n658, n659, n660, n661, n662, n663, n664, n665, n666,
         n667, n668, n669, n670, n671, n672, n673, n674, n675, n676, n677,
         n678, n679, n680, n681, n682, n683, n684, n685, n686, n687, n688,
         n689, n690, n691, n692, n693, n694, n695, n696, n697, n698, n699,
         n7000, n7010, n7020, n7030, n7040, n7050, n7060, n7070, n7080, n7090,
         n7100, n7110, n7120, n7130, n7140, n7150, n7160, n7170, n7180, n7190,
         n7200, n7210, n7220, n7230, n724, n725, n726, n727, n728, n729, n730,
         n731, n732, n733, n734, n735, n736, n737, n738, n739, n740, n741,
         n742, n743, n744, n745, n746, n747, n748, n749, n750, n751, n752,
         n753, intadd_2_A_1_, intadd_2_A_0_, intadd_3_A_2_, intadd_3_A_1_,
         intadd_3_B_2_, intadd_3_B_1_, intadd_3_B_0_, intadd_3_CI,
         intadd_3_SUM_0_, intadd_3_n3, intadd_3_n2, intadd_3_n1, n763, n764,
         n765, n766, n767, n768, n769, n770, n771, n772, n773, n774, n775,
         n776, n777, n778, n779, n780, n781, n782, n783, n784, n785, n786,
         n787, n788, n789, n790, n791, n792, n793, n794, n795, n796, n797,
         n798, n799, n800, n801, n802, n803, n804, n805, n806, n807, n808,
         n809, n810, n811, n812, n813, n814, n815, n816, n817, n818, n819,
         n820, n821, n822, n823, n824, n825, n826, n827, n828, n829, n830,
         n831, n832, n833, n834, n835, n836, n837, n838, n839, n840, n841,
         n842, n843, n844, n845, n846, n847, n848, n849, n850, n851, n852,
         n853, n854, n855, n856, n857, n858, n859, n860, n861, n862, n863,
         n864, n865, n866, n867, n868, n869, n870, n871, n872, n873, n874,
         n875, n876, n877, n878, n879, n880, n881, n882, n883, n884, n885,
         n886, n887, n888, n889, n890, n891, n892, n893, n894, n895, n896,
         n897, n898, n899, n900, n901, n902, n903, n904, n905, n906, n907,
         n908, n909, n910, n911, n912, n913, n914, n915, n916, n917, n918,
         n919, n920, n921, n922, n923, n924, n925, n926, n927, n928, n929,
         n930, n931, n932, n933, n934, n935, n936, n937, n938, n939, n940,
         n941, n942, n943, n944, n945, n946, n947, n948, n949, n950, n951,
         n952, n953, n954, n955, n956, n957, n958, n959, n960, n961, n962,
         n963, n9640, n965, n966, n967, n968, n969, n970, n971, n972, n973,
         n974, n975, n976, n977, n978, n979, n980, n981, n982, n983, n984,
         n985, n986, n987, n988, n989, n990, n991, n992, n993, n994, n995,
         n996, n997, n998, n999, n1000, n1001, n1002, n1003, n1004, n1005,
         n1006, n1007, n1008, n1009, n1010, n1011, n1012, n1013, n1014, n1015,
         n1016, n1017, n1018, n1019, n1020, n1021, n1022, n1023, n1024, n1025,
         n1026, n1027, n1028, n1029, n1030, n1031, n1032, n1033, n1034, n1035,
         n1036, n1037, n1038, n1039, n1040, n1041, n1042, n1043, n1044, n1045,
         n1046, n1047, n1048, n1049, n1050, n1051, n1052, n1053, n1054, n1055,
         n1056, n1057, n1058, n1059, n1060, n1061, n1062, n1063, n1064, n1065,
         n1066, n1067, n1068, n1069, n1070, n1071, n1072, n1073, n1074, n1075,
         n1076, n1077, n1078, n1079, n1080, n1081, n1082, n1083, n1084, n1085,
         n1086, n1087, n1088, n1089, n1090, n1091, n1092, n1093, n1094, n1095,
         n1096, n1097, n1098, n1099, n1100, n1101, n1102, n1103, n1104, n1105,
         n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113, n1114, n1115,
         n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123, n1124, n1125,
         n1126, n1127, n1128, n1129, n1130, n1131, n1132, n1133, n1134, n1135,
         n1136, n1137, n1138, n1139, n1140, n1141, n1142, n1143, n1144, n1145,
         n1146, n1147, n1148, n1149, n1150, n1151, n1152, n1153, n1154, n1155,
         n1156, n1157, n1158, n1159, n1160, n1161, n1162, n1163, n1164, n1165,
         n1166, n1167, n1168, n1169, n1170, n1171, n1172, n1173, n1174, n1175,
         n1176, n1177, n1178, n1179, n1180, n1181, n1182, n1183, n1184, n1185,
         n1186, n1187, n1188, n1189, n1190, n1191, n1192, n1193, n1194, n1195,
         n1196, n1197, n1198, n1199, n1200, n1201, n1202, n1203, n1204, n1205,
         n1206, n1207, n1208, n1209, n1210, n1211, n1212, n1213, n1214, n1215,
         n1216, n1217, n1218, n1219, n1220, n1221, n1222, n1223, n1224, n1225,
         n1226, n1227, n1228, n1229, n1230, n1231, n1232, n1233, n1234, n1235,
         n1236, n1237, n1238, n1239, n1240, n1241, n1242, n1243, n1244, n1245,
         n1246, n1247, n1248, n1249, n1250, n1251, n1252, n1253, n1254, n1255,
         n1256, n1257, n1258, n1259, n1260, n1261, n1262, n1263, n1264, n1265,
         n1266, n1267, n1268, n1269, n1270, n1271, n1272, n1273, n1274, n1275,
         n1276, n1277, n1278, n1279, n1280, n1281, n1282, n1283, n1284, n1285,
         n1286, n1287, n1288, n1289, n1290, n1291, n1292, n1293, n1294, n1295,
         n1296, n1297, n1298, n1299, n1300, n1301, n1302, n1303, n1304, n1305,
         n1306, n1307, n1308, n1309, n1310, n1311, n1312, n1313, n1314, n1315,
         n1316, n1317, n1318, n1319, n1320, n1321, n1322, n1323, n1324, n1325,
         n1326, n1327, n1328, n1329, n1330, n1331, n1332, n1333, n1334, n1335,
         n1336, n1337, n1338, n1339, n1340, n1341, n1342, n1343, n1344, n1345,
         n1346, n1347, n1348, n1349, n1350, n1351, n1352, n1353, n1354, n1355,
         n1356, n1357, n1358, n1359, n1360, n1361, n1362, n1363, n1364, n1365,
         n1366, n1367, n1368, n1369, n1370, n1371, n1372, n1373, n1374, n1375,
         n1376, n1377, n1378, n1379, n1380, n1381, n1382, n1383, n1384, n1385,
         n1386, n1387, n1388, n1389, n1390, n1391, n1392, n1393, n1394, n1395,
         n1396, n1397, n1398, n1399, n1400, n1401, n1402, n1403, n1404, n1405,
         n1406, n1407, n1408, n1409, n1410, n1411, n1412, n1413, n1414, n1415,
         n1416, n1417, n1418, n1419, n1420, n1421, n1422, n1423, n1424, n1425,
         n1426, n1427, n1428, n1429, n1430, n1431, n1432, n1433, n1434, n1435,
         n1436, n1437, n1438, n1439, n1440, n1441, n1442, n1443, n1444, n1445,
         n1446, n1447, n1448, n1449, n1450, n1451, n1452, n1453, n1454, n1455,
         n1456, n1457, n1458, n1459, n1460, n1461, n1462, n1463, n1464, n1465,
         n1466, n1467, n1468, n1469, n1470, n1471, n1472, n1473, n1474, n1475,
         n1476, n1477, n1478, n1479, n1480, n1481, n1482;
  wire   [2:0] state;
  wire   [3:0] cnt_f;
  wire   [3:0] cnt;
  wire   [10:0] bottom_f;
  wire   [2:0] position_f;
  wire   [23:0] tetrominoes_map_f;
  wire   [2:0] bottom_compare_f;
  wire   [23:0] col_top_f;
  wire   [23:0] row_f;
  wire   [3:0] score_f;
  wire   [3:0] score_comb;
  wire   [71:0] tetris_comb;
  wire   [23:0] col_top;

  QDFFRBS state_reg_0_ ( .D(next_state_0_), .CK(clk), .RB(n1475), .Q(state[0])
         );
  QDFFRBS state_reg_2_ ( .D(n1473), .CK(clk), .RB(n1475), .Q(state[2]) );
  QDFFRBS tetrominoes_map_f_reg_3__0_ ( .D(n753), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[18]) );
  QDFFRBS tetrominoes_map_f_reg_3__1_ ( .D(n752), .CK(clk), .RB(n1476), .Q(
        tetrominoes_map_f[19]) );
  QDFFRBS tetrominoes_map_f_reg_3__2_ ( .D(n751), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[20]) );
  QDFFRBS tetrominoes_map_f_reg_3__3_ ( .D(n750), .CK(clk), .RB(n1476), .Q(
        tetrominoes_map_f[21]) );
  QDFFRBS tetrominoes_map_f_reg_3__4_ ( .D(n749), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[22]) );
  QDFFRBS tetrominoes_map_f_reg_3__5_ ( .D(n748), .CK(clk), .RB(n1475), .Q(
        tetrominoes_map_f[23]) );
  QDFFRBS tetrominoes_map_f_reg_2__0_ ( .D(n747), .CK(clk), .RB(n1476), .Q(
        tetrominoes_map_f[12]) );
  QDFFRBS tetrominoes_map_f_reg_2__1_ ( .D(n746), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[13]) );
  QDFFRBS tetrominoes_map_f_reg_2__2_ ( .D(n745), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[14]) );
  QDFFRBS tetrominoes_map_f_reg_2__3_ ( .D(n744), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[15]) );
  QDFFRBS tetrominoes_map_f_reg_2__4_ ( .D(n743), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[16]) );
  QDFFRBS tetrominoes_map_f_reg_2__5_ ( .D(n742), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[17]) );
  QDFFRBS tetrominoes_map_f_reg_1__0_ ( .D(n741), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[6]) );
  QDFFRBS tetrominoes_map_f_reg_1__1_ ( .D(n740), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[7]) );
  QDFFRBS tetrominoes_map_f_reg_1__2_ ( .D(n739), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[8]) );
  QDFFRBS tetrominoes_map_f_reg_1__3_ ( .D(n738), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[9]) );
  QDFFRBS tetrominoes_map_f_reg_1__4_ ( .D(n737), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[10]) );
  QDFFRBS tetrominoes_map_f_reg_1__5_ ( .D(n736), .CK(clk), .RB(n1474), .Q(
        tetrominoes_map_f[11]) );
  QDFFRBS tetrominoes_map_f_reg_0__0_ ( .D(n735), .CK(clk), .RB(n1475), .Q(
        tetrominoes_map_f[0]) );
  QDFFRBS tetrominoes_map_f_reg_0__1_ ( .D(n734), .CK(clk), .RB(n1475), .Q(
        tetrominoes_map_f[1]) );
  QDFFRBS tetrominoes_map_f_reg_0__2_ ( .D(n733), .CK(clk), .RB(n1475), .Q(
        tetrominoes_map_f[2]) );
  QDFFRBS tetrominoes_map_f_reg_0__3_ ( .D(n732), .CK(clk), .RB(n1475), .Q(
        tetrominoes_map_f[3]) );
  QDFFRBS tetrominoes_map_f_reg_0__4_ ( .D(n731), .CK(clk), .RB(n1475), .Q(
        tetrominoes_map_f[4]) );
  QDFFRBS tetrominoes_map_f_reg_0__5_ ( .D(n730), .CK(clk), .RB(n1475), .Q(
        tetrominoes_map_f[5]) );
  QDFFRBS bottom_f_reg_3__3_ ( .D(n1465), .CK(clk), .RB(n1475), .Q(
        bottom_f[10]) );
  QDFFRBS bottom_f_reg_3__2_ ( .D(n1465), .CK(clk), .RB(n1475), .Q(bottom_f[9]) );
  QDFFRBS bottom_f_reg_2__3_ ( .D(n1466), .CK(clk), .RB(n1475), .Q(bottom_f[8]) );
  QDFFRBS bottom_f_reg_2__2_ ( .D(n1466), .CK(clk), .RB(n1475), .Q(bottom_f[7]) );
  QDFFRBS bottom_f_reg_2__0_ ( .D(bottom_2__0_), .CK(clk), .RB(n1475), .Q(
        bottom_f[6]) );
  QDFFRBS bottom_f_reg_1__3_ ( .D(n1467), .CK(clk), .RB(n1476), .Q(bottom_f[5]) );
  QDFFRBS bottom_f_reg_1__2_ ( .D(n1467), .CK(clk), .RB(n1476), .Q(bottom_f[4]) );
  QDFFRBS bottom_f_reg_1__0_ ( .D(bottom_1__0_), .CK(clk), .RB(n1476), .Q(
        bottom_f[3]) );
  QDFFRBS bottom_f_reg_0__2_ ( .D(n763), .CK(clk), .RB(n1476), .Q(bottom_f[2])
         );
  QDFFRBS bottom_f_reg_0__1_ ( .D(n1468), .CK(clk), .RB(n1476), .Q(bottom_f[1]) );
  QDFFRBS bottom_f_reg_0__0_ ( .D(bottom_0__0_), .CK(clk), .RB(n1476), .Q(
        bottom_f[0]) );
  QDFFRBS map_f_reg_0__0_ ( .D(n660), .CK(clk), .RB(n1476), .Q(map_f_0__0_) );
  QDFFRBS row_f_reg_0__0_ ( .D(N700), .CK(clk), .RB(n1476), .Q(row_f[0]) );
  QDFFRBS bottom_compare_f_reg_2_ ( .D(n7190), .CK(clk), .RB(n1476), .Q(
        bottom_compare_f[2]) );
  QDFFRBS bottom_compare_f_reg_3_ ( .D(n729), .CK(clk), .RB(n1474), .Q(N964)
         );
  QDFFRBS map_f_reg_10__1_ ( .D(n649), .CK(clk), .RB(n1475), .Q(map_f_10__1_)
         );
  QDFFRBS map_f_reg_9__1_ ( .D(n7030), .CK(clk), .RB(n1476), .Q(map_f_9__1_)
         );
  QDFFRBS map_f_reg_8__1_ ( .D(n697), .CK(clk), .RB(n1475), .Q(map_f_8__1_) );
  QDFFRBS map_f_reg_7__1_ ( .D(n727), .CK(clk), .RB(n1476), .Q(map_f_7__1_) );
  QDFFRBS map_f_reg_6__1_ ( .D(n691), .CK(clk), .RB(n1475), .Q(map_f_6__1_) );
  QDFFRBS map_f_reg_5__1_ ( .D(n685), .CK(clk), .RB(n1474), .Q(map_f_5__1_) );
  QDFFRBS map_f_reg_4__1_ ( .D(n655), .CK(clk), .RB(n1476), .Q(map_f_4__1_) );
  QDFFRBS map_f_reg_3__1_ ( .D(n679), .CK(clk), .RB(n1476), .Q(map_f_3__1_) );
  QDFFRBS map_f_reg_2__1_ ( .D(n673), .CK(clk), .RB(n1475), .Q(map_f_2__1_) );
  QDFFRBS map_f_reg_1__1_ ( .D(n667), .CK(clk), .RB(n1474), .Q(map_f_1__1_) );
  QDFFRBS map_f_reg_0__1_ ( .D(n661), .CK(clk), .RB(n1474), .Q(map_f_0__1_) );
  QDFFRBS row_f_reg_0__1_ ( .D(N701), .CK(clk), .RB(n1479), .Q(row_f[1]) );
  QDFFRBS map_f_reg_12__1_ ( .D(n7150), .CK(clk), .RB(n1479), .Q(map_f_12__1_)
         );
  QDFFRBS cnt_f_reg_0_ ( .D(cnt[0]), .CK(clk), .RB(n1479), .Q(cnt_f[0]) );
  QDFFRBS cnt_f_reg_1_ ( .D(cnt[1]), .CK(clk), .RB(n1479), .Q(cnt_f[1]) );
  QDFFRBS cnt_f_reg_2_ ( .D(cnt[2]), .CK(clk), .RB(n1479), .Q(cnt_f[2]) );
  QDFFRBS cnt_f_reg_3_ ( .D(cnt[3]), .CK(clk), .RB(n1479), .Q(cnt_f[3]) );
  QDFFRBS map_f_reg_12__0_ ( .D(n7140), .CK(clk), .RB(n1479), .Q(map_f_12__0_)
         );
  QDFFRBS map_f_reg_11__0_ ( .D(n7080), .CK(clk), .RB(n1479), .Q(map_f_11__0_)
         );
  QDFFRBS map_f_reg_10__5_ ( .D(n653), .CK(clk), .RB(n1479), .Q(map_f_10__5_)
         );
  QDFFRBS map_f_reg_9__5_ ( .D(n7070), .CK(clk), .RB(n1479), .Q(map_f_9__5_)
         );
  QDFFRBS map_f_reg_8__5_ ( .D(n7010), .CK(clk), .RB(n1479), .Q(map_f_8__5_)
         );
  QDFFRBS map_f_reg_7__5_ ( .D(n7230), .CK(clk), .RB(n1479), .Q(map_f_7__5_)
         );
  QDFFRBS map_f_reg_6__5_ ( .D(n695), .CK(clk), .RB(n1479), .Q(map_f_6__5_) );
  QDFFRBS map_f_reg_5__5_ ( .D(n689), .CK(clk), .RB(n1479), .Q(map_f_5__5_) );
  QDFFRBS map_f_reg_4__5_ ( .D(n659), .CK(clk), .RB(n1479), .Q(map_f_4__5_) );
  QDFFRBS map_f_reg_3__5_ ( .D(n683), .CK(clk), .RB(n1479), .Q(map_f_3__5_) );
  QDFFRBS map_f_reg_2__5_ ( .D(n677), .CK(clk), .RB(n1479), .Q(map_f_2__5_) );
  QDFFRBS map_f_reg_1__5_ ( .D(n671), .CK(clk), .RB(n1479), .Q(map_f_1__5_) );
  QDFFRBS map_f_reg_0__5_ ( .D(n665), .CK(clk), .RB(n1479), .Q(map_f_0__5_) );
  QDFFRBS row_f_reg_0__5_ ( .D(N705), .CK(clk), .RB(n1479), .Q(row_f[5]) );
  QDFFRBS map_f_reg_12__5_ ( .D(n7220), .CK(clk), .RB(n1479), .Q(map_f_12__5_)
         );
  QDFFRBS map_f_reg_11__5_ ( .D(n7130), .CK(clk), .RB(n1479), .Q(map_f_11__5_)
         );
  QDFFRBS row_f_reg_3__5_ ( .D(N723), .CK(clk), .RB(n1479), .Q(row_f[23]) );
  QDFFRBS row_f_reg_2__5_ ( .D(N717), .CK(clk), .RB(n1479), .Q(row_f[17]) );
  QDFFRBS row_f_reg_1__5_ ( .D(N711), .CK(clk), .RB(n1479), .Q(row_f[11]) );
  QDFFRBS map_f_reg_10__4_ ( .D(n652), .CK(clk), .RB(n1479), .Q(map_f_10__4_)
         );
  QDFFRBS map_f_reg_9__4_ ( .D(n7060), .CK(clk), .RB(n1479), .Q(map_f_9__4_)
         );
  QDFFRBS map_f_reg_8__4_ ( .D(n7000), .CK(clk), .RB(n1479), .Q(map_f_8__4_)
         );
  QDFFRBS map_f_reg_7__4_ ( .D(n724), .CK(clk), .RB(n1479), .Q(map_f_7__4_) );
  QDFFRBS map_f_reg_6__4_ ( .D(n694), .CK(clk), .RB(n1479), .Q(map_f_6__4_) );
  QDFFRBS map_f_reg_5__4_ ( .D(n688), .CK(clk), .RB(n1479), .Q(map_f_5__4_) );
  QDFFRBS map_f_reg_4__4_ ( .D(n658), .CK(clk), .RB(n1479), .Q(map_f_4__4_) );
  QDFFRBS map_f_reg_3__4_ ( .D(n682), .CK(clk), .RB(n1474), .Q(map_f_3__4_) );
  QDFFRBS map_f_reg_2__4_ ( .D(n676), .CK(clk), .RB(n1475), .Q(map_f_2__4_) );
  QDFFRBS map_f_reg_1__4_ ( .D(n670), .CK(clk), .RB(n1476), .Q(map_f_1__4_) );
  QDFFRBS map_f_reg_0__4_ ( .D(n664), .CK(clk), .RB(n1475), .Q(map_f_0__4_) );
  QDFFRBS row_f_reg_0__4_ ( .D(N704), .CK(clk), .RB(n1476), .Q(row_f[4]) );
  QDFFRBS map_f_reg_12__4_ ( .D(n7180), .CK(clk), .RB(n1474), .Q(map_f_12__4_)
         );
  QDFFRBS map_f_reg_11__4_ ( .D(n7120), .CK(clk), .RB(n1476), .Q(map_f_11__4_)
         );
  QDFFRBS row_f_reg_3__4_ ( .D(N722), .CK(clk), .RB(n1474), .Q(row_f[22]) );
  QDFFRBS row_f_reg_2__4_ ( .D(N716), .CK(clk), .RB(n1476), .Q(row_f[16]) );
  QDFFRBS row_f_reg_1__4_ ( .D(N710), .CK(clk), .RB(n1475), .Q(row_f[10]) );
  QDFFRBS map_f_reg_10__3_ ( .D(n651), .CK(clk), .RB(n1475), .Q(map_f_10__3_)
         );
  QDFFRBS map_f_reg_9__3_ ( .D(n7050), .CK(clk), .RB(n1474), .Q(map_f_9__3_)
         );
  QDFFRBS map_f_reg_8__3_ ( .D(n699), .CK(clk), .RB(n1481), .Q(map_f_8__3_) );
  QDFFRBS map_f_reg_7__3_ ( .D(n725), .CK(clk), .RB(n1481), .Q(map_f_7__3_) );
  QDFFRBS map_f_reg_6__3_ ( .D(n693), .CK(clk), .RB(n1481), .Q(map_f_6__3_) );
  QDFFRBS map_f_reg_5__3_ ( .D(n687), .CK(clk), .RB(n1481), .Q(map_f_5__3_) );
  QDFFRBS map_f_reg_4__3_ ( .D(n657), .CK(clk), .RB(n1480), .Q(map_f_4__3_) );
  QDFFRBS map_f_reg_3__3_ ( .D(n681), .CK(clk), .RB(n1481), .Q(map_f_3__3_) );
  QDFFRBS map_f_reg_2__3_ ( .D(n675), .CK(clk), .RB(n1480), .Q(map_f_2__3_) );
  QDFFRBS map_f_reg_1__3_ ( .D(n669), .CK(clk), .RB(rst_n), .Q(map_f_1__3_) );
  QDFFRBS map_f_reg_0__3_ ( .D(n663), .CK(clk), .RB(rst_n), .Q(map_f_0__3_) );
  QDFFRBS row_f_reg_0__3_ ( .D(N703), .CK(clk), .RB(n1476), .Q(row_f[3]) );
  QDFFRBS map_f_reg_12__3_ ( .D(n7170), .CK(clk), .RB(n1475), .Q(map_f_12__3_)
         );
  QDFFRBS map_f_reg_11__3_ ( .D(n7110), .CK(clk), .RB(n1476), .Q(map_f_11__3_)
         );
  QDFFRBS row_f_reg_3__3_ ( .D(N721), .CK(clk), .RB(n1475), .Q(row_f[21]) );
  QDFFRBS row_f_reg_2__3_ ( .D(N715), .CK(clk), .RB(n1476), .Q(row_f[15]) );
  QDFFRBS row_f_reg_1__3_ ( .D(N709), .CK(clk), .RB(n1474), .Q(row_f[9]) );
  QDFFRBS map_f_reg_10__2_ ( .D(n650), .CK(clk), .RB(n1474), .Q(map_f_10__2_)
         );
  QDFFRBS map_f_reg_9__2_ ( .D(n7040), .CK(clk), .RB(n1475), .Q(map_f_9__2_)
         );
  QDFFRBS map_f_reg_8__2_ ( .D(n698), .CK(clk), .RB(n1476), .Q(map_f_8__2_) );
  QDFFRBS map_f_reg_7__2_ ( .D(n726), .CK(clk), .RB(n1474), .Q(map_f_7__2_) );
  QDFFRBS map_f_reg_6__2_ ( .D(n692), .CK(clk), .RB(n1475), .Q(map_f_6__2_) );
  QDFFRBS map_f_reg_4__2_ ( .D(n656), .CK(clk), .RB(rst_n), .Q(map_f_4__2_) );
  QDFFRBS map_f_reg_3__2_ ( .D(n680), .CK(clk), .RB(n1480), .Q(map_f_3__2_) );
  QDFFRBS map_f_reg_2__2_ ( .D(n674), .CK(clk), .RB(n1480), .Q(map_f_2__2_) );
  QDFFRBS map_f_reg_1__2_ ( .D(n668), .CK(clk), .RB(n1480), .Q(map_f_1__2_) );
  QDFFRBS map_f_reg_0__2_ ( .D(n662), .CK(clk), .RB(n1475), .Q(map_f_0__2_) );
  QDFFRBS row_f_reg_0__2_ ( .D(N702), .CK(clk), .RB(n1474), .Q(row_f[2]) );
  QDFFRBS map_f_reg_12__2_ ( .D(n7160), .CK(clk), .RB(n1474), .Q(map_f_12__2_)
         );
  QDFFRBS map_f_reg_11__2_ ( .D(n7100), .CK(clk), .RB(n1476), .Q(map_f_11__2_)
         );
  QDFFRBS row_f_reg_3__2_ ( .D(N720), .CK(clk), .RB(n1476), .Q(row_f[20]) );
  QDFFRBS row_f_reg_2__2_ ( .D(N714), .CK(clk), .RB(n1474), .Q(row_f[14]) );
  QDFFRBS row_f_reg_1__2_ ( .D(N708), .CK(clk), .RB(n1475), .Q(row_f[8]) );
  QDFFRBS map_f_reg_11__1_ ( .D(n7090), .CK(clk), .RB(n1477), .Q(map_f_11__1_)
         );
  QDFFRBS row_f_reg_3__1_ ( .D(N719), .CK(clk), .RB(n1477), .Q(row_f[19]) );
  QDFFRBS row_f_reg_2__1_ ( .D(N713), .CK(clk), .RB(n1477), .Q(row_f[13]) );
  QDFFRBS row_f_reg_1__1_ ( .D(N707), .CK(clk), .RB(n1477), .Q(row_f[7]) );
  QDFFRBS map_f_reg_10__0_ ( .D(n648), .CK(clk), .RB(n1477), .Q(map_f_10__0_)
         );
  QDFFRBS map_f_reg_9__0_ ( .D(n7020), .CK(clk), .RB(n1477), .Q(map_f_9__0_)
         );
  QDFFRBS map_f_reg_8__0_ ( .D(n696), .CK(clk), .RB(n1477), .Q(map_f_8__0_) );
  QDFFRBS map_f_reg_7__0_ ( .D(n728), .CK(clk), .RB(n1477), .Q(map_f_7__0_) );
  QDFFRBS map_f_reg_6__0_ ( .D(n690), .CK(clk), .RB(n1477), .Q(map_f_6__0_) );
  QDFFRBS map_f_reg_4__0_ ( .D(n654), .CK(clk), .RB(n1477), .Q(map_f_4__0_) );
  QDFFRBS map_f_reg_3__0_ ( .D(n678), .CK(clk), .RB(n1477), .Q(map_f_3__0_) );
  QDFFRBS row_f_reg_3__0_ ( .D(N718), .CK(clk), .RB(n1480), .Q(row_f[18]) );
  QDFFRBS map_f_reg_2__0_ ( .D(n672), .CK(clk), .RB(n1480), .Q(map_f_2__0_) );
  QDFFRBS row_f_reg_2__0_ ( .D(N712), .CK(clk), .RB(n1480), .Q(row_f[12]) );
  QDFFRBS map_f_reg_1__0_ ( .D(n666), .CK(clk), .RB(n1480), .Q(map_f_1__0_) );
  QDFFRBS row_f_reg_1__0_ ( .D(N706), .CK(clk), .RB(n1480), .Q(row_f[6]) );
  QDFFRBS score_f_reg_0_ ( .D(n647), .CK(clk), .RB(n1480), .Q(score_f[0]) );
  QDFFRBS score_f_reg_1_ ( .D(n646), .CK(clk), .RB(n1480), .Q(score_f[1]) );
  QDFFRBS score_f_reg_2_ ( .D(n645), .CK(clk), .RB(n1480), .Q(score_f[2]) );
  QDFFRBS score_f_reg_3_ ( .D(n644), .CK(clk), .RB(n1480), .Q(score_f[3]) );
  QDFFRBN fail_reg ( .D(n1471), .CK(clk), .RB(n1480), .Q(fail) );
  QDFFRBN tetris_valid_reg ( .D(n1469), .CK(clk), .RB(n1480), .Q(tetris_valid)
         );
  QDFFRBN score_reg_3_ ( .D(score_comb[3]), .CK(clk), .RB(n1480), .Q(score[3])
         );
  QDFFRBN score_reg_2_ ( .D(score_comb[2]), .CK(clk), .RB(n1480), .Q(score[2])
         );
  QDFFRBN score_reg_1_ ( .D(score_comb[1]), .CK(clk), .RB(n1480), .Q(score[1])
         );
  QDFFRBN score_reg_0_ ( .D(score_comb[0]), .CK(clk), .RB(n1480), .Q(score[0])
         );
  QDFFRBN score_valid_reg ( .D(n1470), .CK(clk), .RB(n1480), .Q(score_valid)
         );
  QDFFRBN tetris_reg_71_ ( .D(tetris_comb[71]), .CK(clk), .RB(n1480), .Q(
        tetris[71]) );
  QDFFRBN tetris_reg_70_ ( .D(tetris_comb[70]), .CK(clk), .RB(n1480), .Q(
        tetris[70]) );
  QDFFRBN tetris_reg_69_ ( .D(tetris_comb[69]), .CK(clk), .RB(n1480), .Q(
        tetris[69]) );
  QDFFRBN tetris_reg_68_ ( .D(tetris_comb[68]), .CK(clk), .RB(n1480), .Q(
        tetris[68]) );
  QDFFRBN tetris_reg_67_ ( .D(tetris_comb[67]), .CK(clk), .RB(n1480), .Q(
        tetris[67]) );
  QDFFRBN tetris_reg_66_ ( .D(tetris_comb[66]), .CK(clk), .RB(n1480), .Q(
        tetris[66]) );
  QDFFRBN tetris_reg_65_ ( .D(tetris_comb[65]), .CK(clk), .RB(n1480), .Q(
        tetris[65]) );
  QDFFRBN tetris_reg_64_ ( .D(tetris_comb[64]), .CK(clk), .RB(n1480), .Q(
        tetris[64]) );
  QDFFRBN tetris_reg_63_ ( .D(tetris_comb[63]), .CK(clk), .RB(n1480), .Q(
        tetris[63]) );
  QDFFRBN tetris_reg_62_ ( .D(tetris_comb[62]), .CK(clk), .RB(n1480), .Q(
        tetris[62]) );
  QDFFRBN tetris_reg_61_ ( .D(tetris_comb[61]), .CK(clk), .RB(n1480), .Q(
        tetris[61]) );
  QDFFRBN tetris_reg_60_ ( .D(tetris_comb[60]), .CK(clk), .RB(n1480), .Q(
        tetris[60]) );
  QDFFRBN tetris_reg_59_ ( .D(tetris_comb[59]), .CK(clk), .RB(n1480), .Q(
        tetris[59]) );
  QDFFRBN tetris_reg_58_ ( .D(tetris_comb[58]), .CK(clk), .RB(n1480), .Q(
        tetris[58]) );
  QDFFRBN tetris_reg_57_ ( .D(tetris_comb[57]), .CK(clk), .RB(n1480), .Q(
        tetris[57]) );
  QDFFRBN tetris_reg_56_ ( .D(tetris_comb[56]), .CK(clk), .RB(n1480), .Q(
        tetris[56]) );
  QDFFRBN tetris_reg_55_ ( .D(tetris_comb[55]), .CK(clk), .RB(n1478), .Q(
        tetris[55]) );
  QDFFRBN tetris_reg_54_ ( .D(tetris_comb[54]), .CK(clk), .RB(n1478), .Q(
        tetris[54]) );
  QDFFRBN tetris_reg_53_ ( .D(tetris_comb[53]), .CK(clk), .RB(n1478), .Q(
        tetris[53]) );
  QDFFRBN tetris_reg_52_ ( .D(tetris_comb[52]), .CK(clk), .RB(n1478), .Q(
        tetris[52]) );
  QDFFRBN tetris_reg_51_ ( .D(tetris_comb[51]), .CK(clk), .RB(n1478), .Q(
        tetris[51]) );
  QDFFRBN tetris_reg_50_ ( .D(tetris_comb[50]), .CK(clk), .RB(n1478), .Q(
        tetris[50]) );
  QDFFRBN tetris_reg_49_ ( .D(tetris_comb[49]), .CK(clk), .RB(n1478), .Q(
        tetris[49]) );
  QDFFRBN tetris_reg_48_ ( .D(tetris_comb[48]), .CK(clk), .RB(n1478), .Q(
        tetris[48]) );
  QDFFRBN tetris_reg_47_ ( .D(tetris_comb[47]), .CK(clk), .RB(n1478), .Q(
        tetris[47]) );
  QDFFRBN tetris_reg_46_ ( .D(tetris_comb[46]), .CK(clk), .RB(n1478), .Q(
        tetris[46]) );
  QDFFRBN tetris_reg_45_ ( .D(tetris_comb[45]), .CK(clk), .RB(n1478), .Q(
        tetris[45]) );
  QDFFRBN tetris_reg_44_ ( .D(tetris_comb[44]), .CK(clk), .RB(n1478), .Q(
        tetris[44]) );
  QDFFRBN tetris_reg_43_ ( .D(tetris_comb[43]), .CK(clk), .RB(n1481), .Q(
        tetris[43]) );
  QDFFRBN tetris_reg_42_ ( .D(tetris_comb[42]), .CK(clk), .RB(n1481), .Q(
        tetris[42]) );
  QDFFRBN tetris_reg_41_ ( .D(tetris_comb[41]), .CK(clk), .RB(n1481), .Q(
        tetris[41]) );
  QDFFRBN tetris_reg_40_ ( .D(tetris_comb[40]), .CK(clk), .RB(n1481), .Q(
        tetris[40]) );
  QDFFRBN tetris_reg_39_ ( .D(tetris_comb[39]), .CK(clk), .RB(n1481), .Q(
        tetris[39]) );
  QDFFRBN tetris_reg_38_ ( .D(tetris_comb[38]), .CK(clk), .RB(n1481), .Q(
        tetris[38]) );
  QDFFRBN tetris_reg_37_ ( .D(tetris_comb[37]), .CK(clk), .RB(n1481), .Q(
        tetris[37]) );
  QDFFRBN tetris_reg_36_ ( .D(tetris_comb[36]), .CK(clk), .RB(n1481), .Q(
        tetris[36]) );
  QDFFRBN tetris_reg_35_ ( .D(tetris_comb[35]), .CK(clk), .RB(n1481), .Q(
        tetris[35]) );
  QDFFRBN tetris_reg_34_ ( .D(tetris_comb[34]), .CK(clk), .RB(n1481), .Q(
        tetris[34]) );
  QDFFRBN tetris_reg_33_ ( .D(tetris_comb[33]), .CK(clk), .RB(n1481), .Q(
        tetris[33]) );
  QDFFRBN tetris_reg_32_ ( .D(tetris_comb[32]), .CK(clk), .RB(n1481), .Q(
        tetris[32]) );
  QDFFRBN tetris_reg_31_ ( .D(tetris_comb[31]), .CK(clk), .RB(n1481), .Q(
        tetris[31]) );
  QDFFRBN tetris_reg_30_ ( .D(tetris_comb[30]), .CK(clk), .RB(n1481), .Q(
        tetris[30]) );
  QDFFRBN tetris_reg_29_ ( .D(tetris_comb[29]), .CK(clk), .RB(n1481), .Q(
        tetris[29]) );
  QDFFRBN tetris_reg_28_ ( .D(tetris_comb[28]), .CK(clk), .RB(n1481), .Q(
        tetris[28]) );
  QDFFRBN tetris_reg_27_ ( .D(tetris_comb[27]), .CK(clk), .RB(n1481), .Q(
        tetris[27]) );
  QDFFRBN tetris_reg_26_ ( .D(tetris_comb[26]), .CK(clk), .RB(n1481), .Q(
        tetris[26]) );
  QDFFRBN tetris_reg_25_ ( .D(tetris_comb[25]), .CK(clk), .RB(n1481), .Q(
        tetris[25]) );
  QDFFRBN tetris_reg_24_ ( .D(tetris_comb[24]), .CK(clk), .RB(n1481), .Q(
        tetris[24]) );
  QDFFRBN tetris_reg_23_ ( .D(tetris_comb[23]), .CK(clk), .RB(n1481), .Q(
        tetris[23]) );
  QDFFRBN tetris_reg_22_ ( .D(tetris_comb[22]), .CK(clk), .RB(n1481), .Q(
        tetris[22]) );
  QDFFRBN tetris_reg_21_ ( .D(tetris_comb[21]), .CK(clk), .RB(n1481), .Q(
        tetris[21]) );
  QDFFRBN tetris_reg_20_ ( .D(tetris_comb[20]), .CK(clk), .RB(n1481), .Q(
        tetris[20]) );
  QDFFRBN tetris_reg_19_ ( .D(tetris_comb[19]), .CK(clk), .RB(n1481), .Q(
        tetris[19]) );
  QDFFRBN tetris_reg_18_ ( .D(tetris_comb[18]), .CK(clk), .RB(n1481), .Q(
        tetris[18]) );
  QDFFRBN tetris_reg_17_ ( .D(tetris_comb[17]), .CK(clk), .RB(n1481), .Q(
        tetris[17]) );
  QDFFRBN tetris_reg_16_ ( .D(tetris_comb[16]), .CK(clk), .RB(n1481), .Q(
        tetris[16]) );
  QDFFRBN tetris_reg_15_ ( .D(tetris_comb[15]), .CK(clk), .RB(n1481), .Q(
        tetris[15]) );
  QDFFRBN tetris_reg_14_ ( .D(tetris_comb[14]), .CK(clk), .RB(n1481), .Q(
        tetris[14]) );
  QDFFRBN tetris_reg_13_ ( .D(tetris_comb[13]), .CK(clk), .RB(n1481), .Q(
        tetris[13]) );
  QDFFRBN tetris_reg_12_ ( .D(tetris_comb[12]), .CK(clk), .RB(n1481), .Q(
        tetris[12]) );
  QDFFRBN tetris_reg_11_ ( .D(tetris_comb[11]), .CK(clk), .RB(n1479), .Q(
        tetris[11]) );
  QDFFRBN tetris_reg_10_ ( .D(tetris_comb[10]), .CK(clk), .RB(n1479), .Q(
        tetris[10]) );
  QDFFRBN tetris_reg_9_ ( .D(tetris_comb[9]), .CK(clk), .RB(n1479), .Q(
        tetris[9]) );
  QDFFRBN tetris_reg_8_ ( .D(tetris_comb[8]), .CK(clk), .RB(n1479), .Q(
        tetris[8]) );
  QDFFRBN tetris_reg_7_ ( .D(tetris_comb[7]), .CK(clk), .RB(n1479), .Q(
        tetris[7]) );
  QDFFRBN tetris_reg_6_ ( .D(tetris_comb[6]), .CK(clk), .RB(n1479), .Q(
        tetris[6]) );
  QDFFRBN tetris_reg_5_ ( .D(tetris_comb[5]), .CK(clk), .RB(n1479), .Q(
        tetris[5]) );
  QDFFRBN tetris_reg_4_ ( .D(tetris_comb[4]), .CK(clk), .RB(n1476), .Q(
        tetris[4]) );
  QDFFRBN tetris_reg_3_ ( .D(tetris_comb[3]), .CK(clk), .RB(n1474), .Q(
        tetris[3]) );
  QDFFRBN tetris_reg_2_ ( .D(tetris_comb[2]), .CK(clk), .RB(n1475), .Q(
        tetris[2]) );
  QDFFRBN tetris_reg_1_ ( .D(tetris_comb[1]), .CK(clk), .RB(n1476), .Q(
        tetris[1]) );
  QDFFRBN tetris_reg_0_ ( .D(tetris_comb[0]), .CK(clk), .RB(rst_n), .Q(
        tetris[0]) );
  QDFFRBS col_top_f_reg_5__3_ ( .D(col_top[23]), .CK(clk), .RB(n1476), .Q(
        col_top_f[23]) );
  QDFFRBS col_top_f_reg_5__2_ ( .D(col_top[22]), .CK(clk), .RB(n1474), .Q(
        col_top_f[22]) );
  QDFFRBS col_top_f_reg_5__1_ ( .D(col_top[21]), .CK(clk), .RB(n1475), .Q(
        col_top_f[21]) );
  QDFFRBS col_top_f_reg_5__0_ ( .D(col_top[20]), .CK(clk), .RB(n1474), .Q(
        col_top_f[20]) );
  QDFFRBS col_top_f_reg_4__3_ ( .D(col_top[19]), .CK(clk), .RB(n1476), .Q(
        col_top_f[19]) );
  QDFFRBS col_top_f_reg_4__2_ ( .D(col_top[18]), .CK(clk), .RB(n1474), .Q(
        col_top_f[18]) );
  QDFFRBS col_top_f_reg_4__1_ ( .D(col_top[17]), .CK(clk), .RB(n1475), .Q(
        col_top_f[17]) );
  QDFFRBS col_top_f_reg_4__0_ ( .D(col_top[16]), .CK(clk), .RB(n1475), .Q(
        col_top_f[16]) );
  QDFFRBS col_top_f_reg_3__3_ ( .D(col_top[15]), .CK(clk), .RB(n1476), .Q(
        col_top_f[15]) );
  QDFFRBS col_top_f_reg_3__2_ ( .D(col_top[14]), .CK(clk), .RB(n1474), .Q(
        col_top_f[14]) );
  QDFFRBS col_top_f_reg_3__1_ ( .D(col_top[13]), .CK(clk), .RB(n1475), .Q(
        col_top_f[13]) );
  QDFFRBS col_top_f_reg_3__0_ ( .D(col_top[12]), .CK(clk), .RB(n1474), .Q(
        col_top_f[12]) );
  QDFFRBS col_top_f_reg_2__3_ ( .D(col_top[11]), .CK(clk), .RB(n1476), .Q(
        col_top_f[11]) );
  QDFFRBS col_top_f_reg_2__2_ ( .D(col_top[10]), .CK(clk), .RB(n1476), .Q(
        col_top_f[10]) );
  QDFFRBS col_top_f_reg_2__1_ ( .D(col_top[9]), .CK(clk), .RB(n1474), .Q(
        col_top_f[9]) );
  QDFFRBS col_top_f_reg_2__0_ ( .D(col_top[8]), .CK(clk), .RB(n1475), .Q(
        col_top_f[8]) );
  QDFFRBS col_top_f_reg_1__3_ ( .D(col_top[7]), .CK(clk), .RB(n1476), .Q(
        col_top_f[7]) );
  QDFFRBS col_top_f_reg_1__2_ ( .D(col_top[6]), .CK(clk), .RB(n1474), .Q(
        col_top_f[6]) );
  QDFFRBS col_top_f_reg_1__1_ ( .D(col_top[5]), .CK(clk), .RB(n1476), .Q(
        col_top_f[5]) );
  QDFFRBS col_top_f_reg_1__0_ ( .D(col_top[4]), .CK(clk), .RB(n1474), .Q(
        col_top_f[4]) );
  QDFFRBS col_top_f_reg_0__3_ ( .D(col_top[3]), .CK(clk), .RB(n1475), .Q(
        col_top_f[3]) );
  QDFFRBS col_top_f_reg_0__2_ ( .D(col_top[2]), .CK(clk), .RB(n1475), .Q(
        col_top_f[2]) );
  QDFFRBS col_top_f_reg_0__1_ ( .D(col_top[1]), .CK(clk), .RB(n1474), .Q(
        col_top_f[1]) );
  QDFFRBS col_top_f_reg_0__0_ ( .D(col_top[0]), .CK(clk), .RB(n1475), .Q(
        col_top_f[0]) );
  QDFFRBS position_f_reg_2_ ( .D(n643), .CK(clk), .RB(n1474), .Q(position_f[2]) );
  QDFFRBS position_f_reg_1_ ( .D(n642), .CK(clk), .RB(n1476), .Q(position_f[1]) );
  QDFFRBS position_f_reg_0_ ( .D(n641), .CK(clk), .RB(n1475), .Q(position_f[0]) );
  FA1S intadd_3_U4 ( .A(intadd_3_B_0_), .B(bottom_f[1]), .CI(intadd_3_CI), 
        .CO(intadd_3_n3), .S(intadd_3_SUM_0_) );
  FA1S intadd_3_U3 ( .A(intadd_3_B_1_), .B(intadd_3_A_1_), .CI(intadd_3_n3), 
        .CO(intadd_3_n2), .S(intadd_2_A_0_) );
  FA1S intadd_3_U2 ( .A(intadd_3_B_2_), .B(intadd_3_A_2_), .CI(intadd_3_n2), 
        .CO(intadd_3_n1), .S(intadd_2_A_1_) );
  QDFFRBS bottom_compare_f_reg_0_ ( .D(n7210), .CK(clk), .RB(n1476), .Q(
        bottom_compare_f[0]) );
  QDFFRBS bottom_compare_f_reg_1_ ( .D(n7200), .CK(clk), .RB(n1476), .Q(
        bottom_compare_f[1]) );
  QDFFRBN map_f_reg_5__2_ ( .D(n686), .CK(clk), .RB(n1476), .Q(map_f_5__2_) );
  QDFFRBN map_f_reg_5__0_ ( .D(n684), .CK(clk), .RB(n1477), .Q(map_f_5__0_) );
  DFFRBS state_reg_1_ ( .D(n1472), .CK(clk), .RB(n1475), .Q(state[1]), .QB(
        n1482) );
  INV1S U915 ( .I(in_valid), .O(n763) );
  INV1S U916 ( .I(n763), .O(n764) );
  ND3S U917 ( .I1(n780), .I2(n779), .I3(n778), .O(n823) );
  OA112S U918 ( .C1(n873), .C2(n792), .A1(n777), .B1(n776), .O(n825) );
  ND3S U919 ( .I1(n913), .I2(n912), .I3(n911), .O(intadd_3_B_1_) );
  ND3S U920 ( .I1(n1163), .I2(n1425), .I3(n1328), .O(n1161) );
  ND3S U921 ( .I1(n987), .I2(n986), .I3(n1013), .O(n988) );
  ND3S U922 ( .I1(n951), .I2(n950), .I3(n949), .O(n1201) );
  ND3S U923 ( .I1(n939), .I2(n938), .I3(n937), .O(n1182) );
  ND3S U924 ( .I1(n1234), .I2(n1233), .I3(n1232), .O(n1235) );
  BUF1S U925 ( .I(n1481), .O(n1478) );
  BUF1S U926 ( .I(n1480), .O(n1477) );
  ND3S U927 ( .I1(n890), .I2(n889), .I3(n888), .O(n730) );
  ND3S U928 ( .I1(n879), .I2(n878), .I3(n877), .O(n744) );
  INV1S U929 ( .I(state[2]), .O(n1246) );
  ND2S U930 ( .I1(state[0]), .I2(state[1]), .O(n765) );
  NR2 U931 ( .I1(n1246), .I2(n765), .O(n1470) );
  ND2S U932 ( .I1(n1246), .I2(n765), .O(n1228) );
  INV1S U933 ( .I(n1470), .O(n1249) );
  ND2S U934 ( .I1(n1228), .I2(n1249), .O(n1456) );
  INV1S U935 ( .I(n1456), .O(n1473) );
  ND2S U936 ( .I1(n764), .I2(tetrominoes[1]), .O(n1054) );
  OR3S U937 ( .I1(n1054), .I2(tetrominoes[0]), .I3(tetrominoes[2]), .O(n1465)
         );
  INV1S U938 ( .I(tetrominoes[0]), .O(n1051) );
  ND2S U939 ( .I1(n1051), .I2(tetrominoes[2]), .O(n1055) );
  INV1S U940 ( .I(n1055), .O(n870) );
  INV1S U941 ( .I(tetrominoes[2]), .O(n1222) );
  ND2S U942 ( .I1(n1222), .I2(tetrominoes[0]), .O(n1218) );
  INV1S U943 ( .I(n1218), .O(n766) );
  NR2 U944 ( .I1(n870), .I2(n766), .O(n917) );
  INV1S U945 ( .I(tetrominoes[1]), .O(n1221) );
  NR2 U946 ( .I1(n917), .I2(n1221), .O(n1050) );
  INV1S U947 ( .I(n1050), .O(n1220) );
  ND2S U948 ( .I1(n1221), .I2(n1055), .O(n767) );
  ND3S U949 ( .I1(n764), .I2(n1220), .I3(n767), .O(n1466) );
  OAI12HS U950 ( .B1(n1218), .B2(tetrominoes[1]), .A1(n764), .O(n1467) );
  NR2 U951 ( .I1(n1218), .I2(n1054), .O(n1468) );
  NR2 U952 ( .I1(map_f_12__0_), .I2(map_f_12__1_), .O(n769) );
  NR3 U953 ( .I1(map_f_12__5_), .I2(map_f_12__2_), .I3(map_f_12__3_), .O(n768)
         );
  INV1S U954 ( .I(map_f_12__4_), .O(n1293) );
  AOI13HS U955 ( .B1(n769), .B2(n768), .B3(n1293), .A1(n1249), .O(n1471) );
  NR2 U956 ( .I1(cnt_f[0]), .I2(cnt_f[3]), .O(n770) );
  INV1S U957 ( .I(cnt_f[2]), .O(n1212) );
  INV1S U958 ( .I(cnt_f[1]), .O(n1209) );
  ND3S U959 ( .I1(n770), .I2(n1212), .I3(n1209), .O(n1247) );
  INV1S U960 ( .I(n1471), .O(n1210) );
  OAI12HS U961 ( .B1(n1247), .B2(n1249), .A1(n1210), .O(n1469) );
  MOAI1S U962 ( .A1(state[0]), .A2(n1482), .B1(state[0]), .B2(n1482), .O(n1472) );
  BUF1 U963 ( .I(rst_n), .O(n1479) );
  BUF1 U964 ( .I(rst_n), .O(n1481) );
  BUF1 U965 ( .I(rst_n), .O(n1480) );
  BUF1 U966 ( .I(rst_n), .O(n1476) );
  BUF1 U967 ( .I(rst_n), .O(n1474) );
  BUF1 U968 ( .I(rst_n), .O(n1475) );
  INV1S U969 ( .I(position_f[2]), .O(n1462) );
  ND3S U970 ( .I1(position_f[1]), .I2(position_f[0]), .I3(n1462), .O(n873) );
  INV1S U971 ( .I(n873), .O(n1238) );
  INV1S U972 ( .I(position_f[0]), .O(n1464) );
  INV1S U973 ( .I(position_f[1]), .O(n1463) );
  ND2S U974 ( .I1(position_f[2]), .I2(n1463), .O(n771) );
  NR2 U975 ( .I1(n1464), .I2(n771), .O(n1237) );
  AOI22S U976 ( .A1(n1238), .A2(col_top_f[15]), .B1(n1237), .B2(col_top_f[23]), 
        .O(n775) );
  NR2 U977 ( .I1(position_f[0]), .I2(n771), .O(n1240) );
  ND2S U978 ( .I1(position_f[1]), .I2(n1462), .O(n772) );
  NR2 U979 ( .I1(position_f[0]), .I2(n772), .O(n1239) );
  AOI22S U980 ( .A1(n1240), .A2(col_top_f[19]), .B1(n1239), .B2(col_top_f[11]), 
        .O(n774) );
  ND3S U981 ( .I1(n1464), .I2(n1463), .I3(n1462), .O(n787) );
  INV1S U982 ( .I(n787), .O(n1257) );
  ND3S U983 ( .I1(n1463), .I2(n1462), .I3(position_f[0]), .O(n874) );
  INV1S U984 ( .I(n874), .O(n1256) );
  AOI22S U985 ( .A1(n1257), .A2(col_top_f[3]), .B1(n1256), .B2(col_top_f[7]), 
        .O(n773) );
  ND3S U986 ( .I1(n775), .I2(n774), .I3(n773), .O(intadd_3_B_2_) );
  ND2S U987 ( .I1(bottom_compare_f[1]), .I2(bottom_compare_f[0]), .O(n1418) );
  NR2 U988 ( .I1(bottom_compare_f[2]), .I2(n1418), .O(n859) );
  ND3S U989 ( .I1(state[0]), .I2(n1246), .I3(n1482), .O(n1275) );
  INV1S U990 ( .I(n1275), .O(n1267) );
  INV1S U991 ( .I(col_top_f[16]), .O(n792) );
  AOI22S U992 ( .A1(n1239), .A2(col_top_f[12]), .B1(n1256), .B2(col_top_f[8]), 
        .O(n777) );
  AOI22S U993 ( .A1(n1257), .A2(col_top_f[4]), .B1(col_top_f[20]), .B2(n1240), 
        .O(n776) );
  ND2S U994 ( .I1(n825), .I2(bottom_f[3]), .O(n824) );
  ND2S U995 ( .I1(col_top_f[21]), .I2(n1240), .O(n780) );
  AOI22S U996 ( .A1(n1257), .A2(col_top_f[5]), .B1(n1238), .B2(col_top_f[17]), 
        .O(n779) );
  AOI22S U997 ( .A1(n1239), .A2(col_top_f[13]), .B1(n1256), .B2(col_top_f[9]), 
        .O(n778) );
  NR2 U998 ( .I1(n824), .I2(n823), .O(n840) );
  INV1S U999 ( .I(n1240), .O(n884) );
  INV1S U1000 ( .I(col_top_f[22]), .O(n797) );
  AOI22S U1001 ( .A1(n1239), .A2(col_top_f[14]), .B1(n1256), .B2(col_top_f[10]), .O(n782) );
  AOI22S U1002 ( .A1(n1257), .A2(col_top_f[6]), .B1(n1238), .B2(col_top_f[18]), 
        .O(n781) );
  OA112S U1003 ( .C1(n884), .C2(n797), .A1(n782), .B1(n781), .O(n827) );
  INV1S U1004 ( .I(col_top_f[23]), .O(n786) );
  AOI22S U1005 ( .A1(n1239), .A2(col_top_f[15]), .B1(n1256), .B2(col_top_f[11]), .O(n784) );
  AOI22S U1006 ( .A1(n1257), .A2(col_top_f[7]), .B1(n1238), .B2(col_top_f[19]), 
        .O(n783) );
  OA112S U1007 ( .C1(n884), .C2(n786), .A1(n784), .B1(n783), .O(n821) );
  MOAI1S U1008 ( .A1(bottom_f[2]), .A2(intadd_3_n1), .B1(bottom_f[2]), .B2(
        intadd_3_n1), .O(n785) );
  MOAI1S U1009 ( .A1(intadd_3_B_2_), .A2(n785), .B1(intadd_3_B_2_), .B2(n785), 
        .O(n834) );
  ND2S U1010 ( .I1(n820), .I2(n834), .O(n855) );
  INV1S U1011 ( .I(bottom_f[9]), .O(n806) );
  AO222S U1012 ( .A1(n1257), .A2(col_top_f[14]), .B1(n1256), .B2(col_top_f[18]), .C1(n1239), .C2(col_top_f[22]), .O(n805) );
  NR2 U1013 ( .I1(n806), .I2(n805), .O(n801) );
  INV1S U1014 ( .I(col_top_f[15]), .O(n788) );
  INV1S U1015 ( .I(n1239), .O(n1259) );
  INV1S U1016 ( .I(col_top_f[19]), .O(n789) );
  OA222S U1017 ( .A1(n787), .A2(n788), .B1(n1259), .B2(n786), .C1(n874), .C2(
        n789), .O(n800) );
  MOAI1S U1018 ( .A1(n874), .A2(n788), .B1(n1257), .B2(col_top_f[11]), .O(n791) );
  MOAI1S U1019 ( .A1(n1259), .A2(n789), .B1(n1238), .B2(col_top_f[23]), .O(
        n790) );
  NR2 U1020 ( .I1(n791), .I2(n790), .O(n804) );
  MOAI1S U1021 ( .A1(n792), .A2(n1259), .B1(n1257), .B2(col_top_f[8]), .O(n794) );
  INV1S U1022 ( .I(col_top_f[20]), .O(n1260) );
  MOAI1S U1023 ( .A1(n1260), .A2(n873), .B1(col_top_f[12]), .B2(n1256), .O(
        n793) );
  NR2 U1024 ( .I1(n794), .I2(n793), .O(n811) );
  ND2S U1025 ( .I1(n811), .I2(bottom_f[6]), .O(n810) );
  AOI22S U1026 ( .A1(n1257), .A2(col_top_f[9]), .B1(n1256), .B2(col_top_f[13]), 
        .O(n796) );
  AOI22S U1027 ( .A1(n1238), .A2(col_top_f[21]), .B1(n1239), .B2(col_top_f[17]), .O(n795) );
  ND2S U1028 ( .I1(n796), .I2(n795), .O(n808) );
  NR2 U1029 ( .I1(n810), .I2(n808), .O(n809) );
  AO22S U1030 ( .A1(n1257), .A2(col_top_f[10]), .B1(n1256), .B2(col_top_f[14]), 
        .O(n799) );
  MOAI1S U1031 ( .A1(n873), .A2(n797), .B1(n1239), .B2(col_top_f[18]), .O(n798) );
  NR2 U1032 ( .I1(n799), .I2(n798), .O(n807) );
  AN2S U1033 ( .I1(n815), .I2(n817), .O(n854) );
  FA1S U1034 ( .A(bottom_f[10]), .B(n801), .CI(n800), .CO(n815), .S(n802) );
  INV1S U1035 ( .I(n802), .O(n819) );
  FA1S U1036 ( .A(bottom_f[8]), .B(n804), .CI(n803), .CO(n817), .S(n818) );
  MOAI1S U1037 ( .A1(n806), .A2(n805), .B1(n806), .B2(n805), .O(n837) );
  FA1S U1038 ( .A(bottom_f[7]), .B(n809), .CI(n807), .CO(n803), .S(n836) );
  OAI22S U1039 ( .A1(n810), .A2(n809), .B1(n808), .B2(n809), .O(n849) );
  OA12S U1040 ( .B1(n811), .B2(bottom_f[6]), .A1(n810), .O(n1261) );
  AO222S U1041 ( .A1(n1257), .A2(col_top_f[13]), .B1(n1256), .B2(col_top_f[17]), .C1(col_top_f[21]), .C2(n1239), .O(n850) );
  FA1S U1042 ( .A(n849), .B(n1261), .CI(n850), .CO(n812) );
  FA1S U1043 ( .A(n837), .B(n836), .CI(n812), .CO(n813) );
  MAO222S U1044 ( .A1(n819), .B1(n818), .C1(n813), .O(n816) );
  ND2S U1045 ( .I1(n817), .I2(n816), .O(n814) );
  MOAI1S U1046 ( .A1(n817), .A2(n816), .B1(n815), .B2(n814), .O(n1263) );
  MOAI1S U1047 ( .A1(n1263), .A2(n819), .B1(n1263), .B2(n818), .O(n864) );
  INV1S U1048 ( .I(n820), .O(n833) );
  FA1S U1049 ( .A(bottom_f[5]), .B(n822), .CI(n821), .CO(n820), .S(n835) );
  INV1S U1050 ( .I(n835), .O(n831) );
  AN2S U1051 ( .I1(n824), .I2(n823), .O(n839) );
  NR3 U1052 ( .I1(n840), .I2(intadd_3_SUM_0_), .I3(n839), .O(n826) );
  OA12S U1053 ( .B1(n825), .B2(bottom_f[3]), .A1(n824), .O(n847) );
  MOAI1S U1054 ( .A1(n826), .A2(n847), .B1(intadd_3_SUM_0_), .B2(n839), .O(
        n829) );
  FA1S U1055 ( .A(bottom_f[4]), .B(n840), .CI(n827), .CO(n822), .S(n838) );
  INV1S U1056 ( .I(n838), .O(n828) );
  FA1S U1057 ( .A(n829), .B(intadd_2_A_0_), .CI(n828), .CO(n830) );
  FA1S U1058 ( .A(n831), .B(intadd_2_A_1_), .CI(n830), .CO(n832) );
  MAO222S U1059 ( .A1(n834), .B1(n833), .C1(n832), .O(n842) );
  INV1S U1060 ( .I(n842), .O(n848) );
  OAI22S U1061 ( .A1(n842), .A2(intadd_2_A_1_), .B1(n848), .B2(n835), .O(n863)
         );
  MOAI1S U1062 ( .A1(n1263), .A2(n837), .B1(n1263), .B2(n836), .O(n857) );
  OAI22S U1063 ( .A1(n842), .A2(intadd_2_A_0_), .B1(n848), .B2(n838), .O(n856)
         );
  OR2S U1064 ( .I1(n840), .I2(n839), .O(n841) );
  MOAI1S U1065 ( .A1(n842), .A2(intadd_3_SUM_0_), .B1(n842), .B2(n841), .O(
        n1271) );
  AOI22S U1066 ( .A1(col_top_f[20]), .A2(n1237), .B1(n1238), .B2(col_top_f[12]), .O(n845) );
  AOI22S U1067 ( .A1(n1240), .A2(col_top_f[16]), .B1(n1239), .B2(col_top_f[8]), 
        .O(n844) );
  AOI22S U1068 ( .A1(n1257), .A2(col_top_f[0]), .B1(col_top_f[4]), .B2(n1256), 
        .O(n843) );
  ND3S U1069 ( .I1(n845), .I2(n844), .I3(n843), .O(n1245) );
  INV1S U1070 ( .I(bottom_f[0]), .O(n1244) );
  MOAI1S U1071 ( .A1(n1245), .A2(n1244), .B1(n1245), .B2(n1244), .O(n846) );
  MOAI1S U1072 ( .A1(n848), .A2(n847), .B1(n848), .B2(n846), .O(n1264) );
  MOAI1S U1073 ( .A1(n1263), .A2(n850), .B1(n1263), .B2(n849), .O(n1270) );
  FA1S U1074 ( .A(n1271), .B(n1264), .CI(n1270), .CO(n851) );
  FA1S U1075 ( .A(n857), .B(n856), .CI(n851), .CO(n852) );
  FA1S U1076 ( .A(n864), .B(n863), .CI(n852), .CO(n853) );
  MAO222S U1077 ( .A1(n855), .B1(n854), .C1(n853), .O(n1269) );
  MOAI1S U1078 ( .A1(n1269), .A2(n857), .B1(n1269), .B2(n856), .O(n858) );
  AOI22S U1079 ( .A1(n1473), .A2(n859), .B1(n1267), .B2(n858), .O(n862) );
  OR2S U1080 ( .I1(state[2]), .I2(state[0]), .O(n869) );
  NR2 U1081 ( .I1(row_f[3]), .I2(tetrominoes_map_f[3]), .O(n1283) );
  NR2 U1082 ( .I1(row_f[4]), .I2(tetrominoes_map_f[4]), .O(n1282) );
  NR2 U1083 ( .I1(row_f[2]), .I2(tetrominoes_map_f[2]), .O(n1284) );
  NR2 U1084 ( .I1(row_f[5]), .I2(tetrominoes_map_f[5]), .O(n1255) );
  NR2 U1085 ( .I1(n1284), .I2(n1255), .O(n860) );
  OR2S U1086 ( .I1(row_f[1]), .I2(tetrominoes_map_f[1]), .O(n1286) );
  OR2S U1087 ( .I1(row_f[0]), .I2(tetrominoes_map_f[0]), .O(n1287) );
  ND3S U1088 ( .I1(n860), .I2(n1286), .I3(n1287), .O(n861) );
  NR3 U1089 ( .I1(n1283), .I2(n1282), .I3(n861), .O(n1453) );
  ND2S U1090 ( .I1(n1473), .I2(n1453), .O(n1447) );
  ND3S U1091 ( .I1(n1249), .I2(n869), .I3(n1447), .O(n1280) );
  AO12S U1092 ( .B1(n1473), .B2(n1418), .A1(n1280), .O(n867) );
  MOAI1S U1093 ( .A1(n862), .A2(n1280), .B1(bottom_compare_f[2]), .B2(n867), 
        .O(n7190) );
  INV1S U1094 ( .I(N964), .O(n1339) );
  NR2 U1095 ( .I1(n1339), .I2(bottom_compare_f[2]), .O(n1307) );
  INV1S U1096 ( .I(n1307), .O(n1037) );
  INV1S U1097 ( .I(n1418), .O(n1424) );
  ND2S U1098 ( .I1(n1339), .I2(bottom_compare_f[2]), .O(n959) );
  INV1S U1099 ( .I(n959), .O(n1396) );
  ND2S U1100 ( .I1(n1424), .I2(n1396), .O(n1252) );
  ND2S U1101 ( .I1(n1037), .I2(n1252), .O(n866) );
  MOAI1S U1102 ( .A1(n1269), .A2(n864), .B1(n1269), .B2(n863), .O(n865) );
  AOI22S U1103 ( .A1(n1473), .A2(n866), .B1(n1267), .B2(n865), .O(n868) );
  MOAI1S U1104 ( .A1(n868), .A2(n1280), .B1(N964), .B2(n867), .O(n729) );
  ND2S U1105 ( .I1(tetrominoes_map_f[12]), .I2(n1228), .O(n872) );
  NR2 U1106 ( .I1(n869), .I2(state[1]), .O(n1248) );
  ND2S U1107 ( .I1(n1248), .I2(n764), .O(n1215) );
  INV1S U1108 ( .I(n1215), .O(n1224) );
  NR2 U1109 ( .I1(n1482), .I2(n869), .O(n883) );
  AO12 U1110 ( .B1(n1257), .B2(n883), .A1(n1267), .O(n1236) );
  AOI22S U1111 ( .A1(n1224), .A2(n870), .B1(tetrominoes_map_f[6]), .B2(n1236), 
        .O(n871) );
  ND2S U1112 ( .I1(n1221), .I2(n1224), .O(n1219) );
  ND3S U1113 ( .I1(n872), .I2(n871), .I3(n1219), .O(n741) );
  INV1S U1114 ( .I(n883), .O(n1176) );
  NR2 U1115 ( .I1(n873), .I2(n1176), .O(n1230) );
  ND2S U1116 ( .I1(tetrominoes_map_f[12]), .I2(n1230), .O(n879) );
  NR2 U1117 ( .I1(n874), .I2(n1176), .O(n875) );
  BUF1 U1118 ( .I(n875), .O(n1231) );
  AOI22S U1119 ( .A1(n1231), .A2(tetrominoes_map_f[14]), .B1(
        tetrominoes_map_f[15]), .B2(n1236), .O(n878) );
  NR2 U1120 ( .I1(n1259), .I2(n1176), .O(n876) );
  BUF1 U1121 ( .I(n876), .O(n1229) );
  AOI22S U1122 ( .A1(tetrominoes_map_f[13]), .A2(n1229), .B1(
        tetrominoes_map_f[21]), .B2(n1228), .O(n877) );
  ND2S U1123 ( .I1(tetrominoes_map_f[6]), .I2(n1230), .O(n882) );
  AOI22S U1124 ( .A1(n1231), .A2(tetrominoes_map_f[8]), .B1(
        tetrominoes_map_f[9]), .B2(n1236), .O(n881) );
  AOI22S U1125 ( .A1(tetrominoes_map_f[7]), .A2(n1229), .B1(
        tetrominoes_map_f[15]), .B2(n1228), .O(n880) );
  ND3S U1126 ( .I1(n882), .I2(n881), .I3(n880), .O(n738) );
  AN2S U1127 ( .I1(n1237), .I2(n883), .O(n903) );
  ND2S U1128 ( .I1(n903), .I2(tetrominoes_map_f[18]), .O(n887) );
  NR2 U1129 ( .I1(n884), .I2(n1176), .O(n907) );
  AOI22S U1130 ( .A1(n1229), .A2(tetrominoes_map_f[21]), .B1(
        tetrominoes_map_f[19]), .B2(n907), .O(n886) );
  AOI22S U1131 ( .A1(n1267), .A2(tetrominoes_map_f[23]), .B1(n1230), .B2(
        tetrominoes_map_f[20]), .O(n885) );
  ND3S U1132 ( .I1(n887), .I2(n886), .I3(n885), .O(n748) );
  AOI22S U1133 ( .A1(n1267), .A2(tetrominoes_map_f[5]), .B1(
        tetrominoes_map_f[11]), .B2(n1228), .O(n890) );
  AOI22S U1134 ( .A1(tetrominoes_map_f[2]), .A2(n1230), .B1(
        tetrominoes_map_f[0]), .B2(n903), .O(n889) );
  AOI22S U1135 ( .A1(tetrominoes_map_f[3]), .A2(n1229), .B1(
        tetrominoes_map_f[1]), .B2(n907), .O(n888) );
  AOI22S U1136 ( .A1(n1267), .A2(tetrominoes_map_f[4]), .B1(
        tetrominoes_map_f[10]), .B2(n1228), .O(n893) );
  AOI22S U1137 ( .A1(tetrominoes_map_f[1]), .A2(n1230), .B1(
        tetrominoes_map_f[0]), .B2(n907), .O(n892) );
  AOI22S U1138 ( .A1(tetrominoes_map_f[3]), .A2(n1231), .B1(
        tetrominoes_map_f[2]), .B2(n1229), .O(n891) );
  ND3S U1139 ( .I1(n893), .I2(n892), .I3(n891), .O(n731) );
  AOI22S U1140 ( .A1(tetrominoes_map_f[10]), .A2(n1267), .B1(
        tetrominoes_map_f[16]), .B2(n1228), .O(n896) );
  AOI22S U1141 ( .A1(n1230), .A2(tetrominoes_map_f[7]), .B1(n907), .B2(
        tetrominoes_map_f[6]), .O(n895) );
  AOI22S U1142 ( .A1(n1229), .A2(tetrominoes_map_f[8]), .B1(n1231), .B2(
        tetrominoes_map_f[9]), .O(n894) );
  ND3S U1143 ( .I1(n896), .I2(n895), .I3(n894), .O(n737) );
  AOI22S U1144 ( .A1(tetrominoes_map_f[11]), .A2(n1267), .B1(
        tetrominoes_map_f[17]), .B2(n1228), .O(n899) );
  AOI22S U1145 ( .A1(n1230), .A2(tetrominoes_map_f[8]), .B1(n903), .B2(
        tetrominoes_map_f[6]), .O(n898) );
  AOI22S U1146 ( .A1(n1229), .A2(tetrominoes_map_f[9]), .B1(n907), .B2(
        tetrominoes_map_f[7]), .O(n897) );
  ND3S U1147 ( .I1(n899), .I2(n898), .I3(n897), .O(n736) );
  ND2S U1148 ( .I1(n907), .I2(tetrominoes_map_f[18]), .O(n902) );
  AOI22S U1149 ( .A1(n1230), .A2(tetrominoes_map_f[19]), .B1(n1231), .B2(
        tetrominoes_map_f[21]), .O(n901) );
  AOI22S U1150 ( .A1(n1267), .A2(tetrominoes_map_f[22]), .B1(n1229), .B2(
        tetrominoes_map_f[20]), .O(n900) );
  ND3S U1151 ( .I1(n902), .I2(n901), .I3(n900), .O(n749) );
  AOI22S U1152 ( .A1(tetrominoes_map_f[17]), .A2(n1267), .B1(
        tetrominoes_map_f[23]), .B2(n1228), .O(n906) );
  AOI22S U1153 ( .A1(n1230), .A2(tetrominoes_map_f[14]), .B1(n903), .B2(
        tetrominoes_map_f[12]), .O(n905) );
  AOI22S U1154 ( .A1(n1229), .A2(tetrominoes_map_f[15]), .B1(n907), .B2(
        tetrominoes_map_f[13]), .O(n904) );
  ND3S U1155 ( .I1(n906), .I2(n905), .I3(n904), .O(n742) );
  AOI22S U1156 ( .A1(tetrominoes_map_f[16]), .A2(n1267), .B1(
        tetrominoes_map_f[22]), .B2(n1228), .O(n910) );
  AOI22S U1157 ( .A1(n1230), .A2(tetrominoes_map_f[13]), .B1(n907), .B2(
        tetrominoes_map_f[12]), .O(n909) );
  AOI22S U1158 ( .A1(n1229), .A2(tetrominoes_map_f[14]), .B1(n1231), .B2(
        tetrominoes_map_f[15]), .O(n908) );
  ND3S U1159 ( .I1(n910), .I2(n909), .I3(n908), .O(n743) );
  AOI22S U1160 ( .A1(n1238), .A2(col_top_f[14]), .B1(n1237), .B2(col_top_f[22]), .O(n913) );
  AOI22S U1161 ( .A1(n1240), .A2(col_top_f[18]), .B1(n1239), .B2(col_top_f[10]), .O(n912) );
  AOI22S U1162 ( .A1(n1257), .A2(col_top_f[2]), .B1(n1256), .B2(col_top_f[6]), 
        .O(n911) );
  ND2S U1163 ( .I1(tetrominoes_map_f[6]), .I2(n1229), .O(n916) );
  MOAI1S U1164 ( .A1(n1051), .A2(tetrominoes[1]), .B1(n1051), .B2(
        tetrominoes[1]), .O(n1046) );
  NR2 U1165 ( .I1(n1222), .I2(n1046), .O(n1056) );
  AOI22S U1166 ( .A1(n1224), .A2(n1056), .B1(tetrominoes_map_f[8]), .B2(n1236), 
        .O(n915) );
  AOI22S U1167 ( .A1(tetrominoes_map_f[7]), .A2(n1231), .B1(
        tetrominoes_map_f[14]), .B2(n1228), .O(n914) );
  ND3S U1168 ( .I1(n916), .I2(n915), .I3(n914), .O(n739) );
  ND2S U1169 ( .I1(tetrominoes_map_f[1]), .I2(n1236), .O(n920) );
  AOI22S U1170 ( .A1(n1231), .A2(tetrominoes_map_f[0]), .B1(
        tetrominoes_map_f[7]), .B2(n1228), .O(n919) );
  OAI12HS U1171 ( .B1(tetrominoes[1]), .B2(n917), .A1(n1224), .O(n918) );
  ND3S U1172 ( .I1(n920), .I2(n919), .I3(n918), .O(n734) );
  AOI22S U1173 ( .A1(n1231), .A2(tetrominoes_map_f[13]), .B1(
        tetrominoes_map_f[14]), .B2(n1236), .O(n922) );
  AOI22S U1174 ( .A1(tetrominoes_map_f[12]), .A2(n1229), .B1(
        tetrominoes_map_f[20]), .B2(n1228), .O(n921) );
  ND2S U1175 ( .I1(n922), .I2(n921), .O(n745) );
  AOI22S U1176 ( .A1(n1231), .A2(tetrominoes_map_f[20]), .B1(
        tetrominoes_map_f[21]), .B2(n1236), .O(n924) );
  AOI22S U1177 ( .A1(n1230), .A2(tetrominoes_map_f[18]), .B1(n1229), .B2(
        tetrominoes_map_f[19]), .O(n923) );
  ND2S U1178 ( .I1(n924), .I2(n923), .O(n750) );
  INV1S U1179 ( .I(bottom_compare_f[0]), .O(n1416) );
  NR2 U1180 ( .I1(n1416), .I2(n1176), .O(n1041) );
  NR2 U1181 ( .I1(bottom_compare_f[1]), .I2(n1037), .O(n1300) );
  OA12S U1182 ( .B1(bottom_compare_f[1]), .B2(bottom_compare_f[2]), .A1(N964), 
        .O(n1301) );
  AOI22S U1183 ( .A1(map_f_11__3_), .A2(n1300), .B1(n1301), .B2(map_f_12__3_), 
        .O(n927) );
  NR2 U1184 ( .I1(bottom_compare_f[1]), .I2(n959), .O(n1337) );
  INV1S U1185 ( .I(bottom_compare_f[2]), .O(n1419) );
  ND2S U1186 ( .I1(n1339), .I2(n1419), .O(n1397) );
  NR2 U1187 ( .I1(n1397), .I2(bottom_compare_f[1]), .O(n1370) );
  AOI22S U1188 ( .A1(map_f_7__3_), .A2(n1337), .B1(map_f_3__3_), .B2(n1370), 
        .O(n926) );
  INV1S U1189 ( .I(bottom_compare_f[1]), .O(n1276) );
  NR2 U1190 ( .I1(n1276), .I2(n959), .O(n1325) );
  NR2 U1191 ( .I1(n1276), .I2(n1397), .O(n1355) );
  AOI22S U1192 ( .A1(map_f_9__3_), .A2(n1325), .B1(map_f_5__3_), .B2(n1355), 
        .O(n925) );
  ND3S U1193 ( .I1(n927), .I2(n926), .I3(n925), .O(n1186) );
  AOI22S U1194 ( .A1(n1041), .A2(n1186), .B1(row_f[21]), .B2(n1176), .O(n930)
         );
  ND2S U1195 ( .I1(n1276), .I2(n1416), .O(n1309) );
  NR2 U1196 ( .I1(n1309), .I2(n1176), .O(n1039) );
  INV1S U1197 ( .I(map_f_10__3_), .O(n1432) );
  INV1S U1198 ( .I(n1397), .O(n1356) );
  AOI22S U1199 ( .A1(n1396), .A2(map_f_6__3_), .B1(map_f_2__3_), .B2(n1356), 
        .O(n928) );
  NR2 U1200 ( .I1(n1339), .I2(n1419), .O(n1290) );
  ND2S U1201 ( .I1(n1290), .I2(map_f_12__3_), .O(n1027) );
  OAI112HS U1202 ( .C1(n1432), .C2(n1037), .A1(n928), .B1(n1027), .O(n1026) );
  NR2 U1203 ( .I1(bottom_compare_f[0]), .I2(n1176), .O(n1202) );
  AN2S U1204 ( .I1(bottom_compare_f[1]), .I2(n1202), .O(n1034) );
  INV1S U1205 ( .I(map_f_8__3_), .O(n1315) );
  INV1S U1206 ( .I(map_f_12__3_), .O(n1294) );
  INV1S U1207 ( .I(map_f_4__3_), .O(n1406) );
  OAI222S U1208 ( .A1(n959), .A2(n1315), .B1(n1294), .B2(n1339), .C1(n1397), 
        .C2(n1406), .O(n1185) );
  AOI22S U1209 ( .A1(n1039), .A2(n1026), .B1(n1034), .B2(n1185), .O(n929) );
  ND2S U1210 ( .I1(n930), .I2(n929), .O(N715) );
  AOI22S U1211 ( .A1(map_f_11__2_), .A2(n1300), .B1(n1301), .B2(map_f_12__2_), 
        .O(n933) );
  AOI22S U1212 ( .A1(map_f_7__2_), .A2(n1337), .B1(map_f_3__2_), .B2(n1370), 
        .O(n932) );
  AOI22S U1213 ( .A1(map_f_9__2_), .A2(n1325), .B1(map_f_5__2_), .B2(n1355), 
        .O(n931) );
  ND3S U1214 ( .I1(n933), .I2(n932), .I3(n931), .O(n1190) );
  AOI22S U1215 ( .A1(n1041), .A2(n1190), .B1(row_f[20]), .B2(n1176), .O(n936)
         );
  INV1S U1216 ( .I(map_f_10__2_), .O(n1435) );
  AOI22S U1217 ( .A1(n1396), .A2(map_f_6__2_), .B1(map_f_2__2_), .B2(n1356), 
        .O(n934) );
  ND2S U1218 ( .I1(n1290), .I2(map_f_12__2_), .O(n1035) );
  OAI112HS U1219 ( .C1(n1435), .C2(n1037), .A1(n934), .B1(n1035), .O(n1033) );
  INV1S U1220 ( .I(map_f_8__2_), .O(n1317) );
  INV1S U1221 ( .I(map_f_12__2_), .O(n1295) );
  INV1S U1222 ( .I(map_f_4__2_), .O(n1408) );
  OAI222S U1223 ( .A1(n959), .A2(n1317), .B1(n1295), .B2(n1339), .C1(n1397), 
        .C2(n1408), .O(n1189) );
  AOI22S U1224 ( .A1(n1039), .A2(n1033), .B1(n1034), .B2(n1189), .O(n935) );
  ND2S U1225 ( .I1(n936), .I2(n935), .O(N714) );
  AOI22S U1226 ( .A1(map_f_11__4_), .A2(n1300), .B1(n1301), .B2(map_f_12__4_), 
        .O(n939) );
  AOI22S U1227 ( .A1(map_f_7__4_), .A2(n1337), .B1(map_f_3__4_), .B2(n1370), 
        .O(n938) );
  AOI22S U1228 ( .A1(map_f_9__4_), .A2(n1325), .B1(map_f_5__4_), .B2(n1355), 
        .O(n937) );
  AOI22S U1229 ( .A1(n1041), .A2(n1182), .B1(row_f[22]), .B2(n1176), .O(n942)
         );
  INV1S U1230 ( .I(map_f_10__4_), .O(n1429) );
  AOI22S U1231 ( .A1(n1396), .A2(map_f_6__4_), .B1(map_f_2__4_), .B2(n1356), 
        .O(n940) );
  ND2S U1232 ( .I1(n1290), .I2(map_f_12__4_), .O(n1020) );
  OAI112HS U1233 ( .C1(n1429), .C2(n1037), .A1(n940), .B1(n1020), .O(n1019) );
  INV1S U1234 ( .I(map_f_8__4_), .O(n1313) );
  INV1S U1235 ( .I(map_f_4__4_), .O(n1404) );
  OAI222S U1236 ( .A1(n959), .A2(n1313), .B1(n1293), .B2(n1339), .C1(n1397), 
        .C2(n1404), .O(n1181) );
  AOI22S U1237 ( .A1(n1039), .A2(n1019), .B1(n1034), .B2(n1181), .O(n941) );
  ND2S U1238 ( .I1(n942), .I2(n941), .O(N716) );
  AOI22S U1239 ( .A1(map_f_11__5_), .A2(n1300), .B1(n1301), .B2(map_f_12__5_), 
        .O(n945) );
  AOI22S U1240 ( .A1(map_f_7__5_), .A2(n1337), .B1(map_f_3__5_), .B2(n1370), 
        .O(n944) );
  AOI22S U1241 ( .A1(map_f_9__5_), .A2(n1325), .B1(map_f_5__5_), .B2(n1355), 
        .O(n943) );
  ND3S U1242 ( .I1(n945), .I2(n944), .I3(n943), .O(n1178) );
  AOI22S U1243 ( .A1(n1041), .A2(n1178), .B1(row_f[23]), .B2(n1176), .O(n948)
         );
  INV1S U1244 ( .I(map_f_10__5_), .O(n1426) );
  AOI22S U1245 ( .A1(n1396), .A2(map_f_6__5_), .B1(map_f_2__5_), .B2(n1356), 
        .O(n946) );
  ND2S U1246 ( .I1(n1290), .I2(map_f_12__5_), .O(n1006) );
  OAI112HS U1247 ( .C1(n1426), .C2(n1037), .A1(n946), .B1(n1006), .O(n1005) );
  INV1S U1248 ( .I(map_f_8__5_), .O(n1311) );
  INV1S U1249 ( .I(map_f_12__5_), .O(n1292) );
  INV1S U1250 ( .I(map_f_4__5_), .O(n1402) );
  OAI222S U1251 ( .A1(n959), .A2(n1311), .B1(n1292), .B2(n1339), .C1(n1397), 
        .C2(n1402), .O(n1177) );
  AOI22S U1252 ( .A1(n1039), .A2(n1005), .B1(n1034), .B2(n1177), .O(n947) );
  ND2S U1253 ( .I1(n948), .I2(n947), .O(N717) );
  AOI22S U1254 ( .A1(map_f_11__0_), .A2(n1300), .B1(n1301), .B2(map_f_12__0_), 
        .O(n951) );
  AOI22S U1255 ( .A1(map_f_7__0_), .A2(n1337), .B1(map_f_3__0_), .B2(n1370), 
        .O(n950) );
  AOI22S U1256 ( .A1(map_f_9__0_), .A2(n1325), .B1(map_f_5__0_), .B2(n1355), 
        .O(n949) );
  AOI22S U1257 ( .A1(n1041), .A2(n1201), .B1(row_f[18]), .B2(n1176), .O(n954)
         );
  INV1S U1258 ( .I(map_f_10__0_), .O(n1443) );
  AOI22S U1259 ( .A1(n1396), .A2(map_f_6__0_), .B1(map_f_2__0_), .B2(n1356), 
        .O(n952) );
  ND2S U1260 ( .I1(n1290), .I2(map_f_12__0_), .O(n1013) );
  OAI112HS U1261 ( .C1(n1443), .C2(n1037), .A1(n952), .B1(n1013), .O(n1012) );
  INV1S U1262 ( .I(map_f_8__0_), .O(n1323) );
  INV1S U1263 ( .I(map_f_12__0_), .O(n1299) );
  INV1S U1264 ( .I(map_f_4__0_), .O(n1414) );
  OAI222S U1265 ( .A1(n959), .A2(n1323), .B1(n1299), .B2(n1339), .C1(n1397), 
        .C2(n1414), .O(n1199) );
  AOI22S U1266 ( .A1(n1039), .A2(n1012), .B1(n1034), .B2(n1199), .O(n953) );
  ND2S U1267 ( .I1(n954), .I2(n953), .O(N712) );
  AOI22S U1268 ( .A1(map_f_11__1_), .A2(n1300), .B1(n1301), .B2(map_f_12__1_), 
        .O(n957) );
  AOI22S U1269 ( .A1(map_f_7__1_), .A2(n1337), .B1(map_f_3__1_), .B2(n1370), 
        .O(n956) );
  AOI22S U1270 ( .A1(map_f_9__1_), .A2(n1325), .B1(map_f_5__1_), .B2(n1355), 
        .O(n955) );
  ND3S U1271 ( .I1(n957), .I2(n956), .I3(n955), .O(n1194) );
  AOI22S U1272 ( .A1(n1041), .A2(n1194), .B1(row_f[19]), .B2(n1176), .O(n961)
         );
  INV1S U1273 ( .I(map_f_10__1_), .O(n1438) );
  AOI22S U1274 ( .A1(n1396), .A2(map_f_6__1_), .B1(map_f_2__1_), .B2(n1356), 
        .O(n958) );
  ND2S U1275 ( .I1(n1290), .I2(map_f_12__1_), .O(n999) );
  OAI112HS U1276 ( .C1(n1438), .C2(n1037), .A1(n958), .B1(n999), .O(n998) );
  INV1S U1277 ( .I(map_f_8__1_), .O(n1319) );
  INV1S U1278 ( .I(map_f_12__1_), .O(n1296) );
  INV1S U1279 ( .I(map_f_4__1_), .O(n1410) );
  OAI222S U1280 ( .A1(n959), .A2(n1319), .B1(n1296), .B2(n1339), .C1(n1397), 
        .C2(n1410), .O(n1193) );
  AOI22S U1281 ( .A1(n1039), .A2(n998), .B1(n1034), .B2(n1193), .O(n960) );
  ND2S U1282 ( .I1(n961), .I2(n960), .O(N713) );
  INV1S U1283 ( .I(map_f_1__4_), .O(n1384) );
  INV1S U1284 ( .I(n1370), .O(n1380) );
  MOAI1S U1285 ( .A1(n1384), .A2(n1380), .B1(map_f_3__4_), .B2(n1355), .O(n965) );
  NR2 U1286 ( .I1(n1276), .I2(n1037), .O(n1417) );
  ND2S U1287 ( .I1(map_f_11__4_), .I2(n1417), .O(n963) );
  AOI22S U1288 ( .A1(map_f_9__4_), .A2(n1300), .B1(map_f_5__4_), .B2(n1337), 
        .O(n962) );
  ND3S U1289 ( .I1(n963), .I2(n962), .I3(n1020), .O(n9640) );
  AO112S U1290 ( .C1(map_f_7__4_), .C2(n1325), .A1(n965), .B1(n9640), .O(n1023) );
  AN2S U1291 ( .I1(n1276), .I2(n1041), .O(n1200) );
  AOI22S U1292 ( .A1(n1202), .A2(n1023), .B1(n1200), .B2(n1019), .O(n967) );
  NR2 U1293 ( .I1(n1418), .I2(n1176), .O(n1175) );
  AOI22S U1294 ( .A1(n1175), .A2(n1181), .B1(row_f[16]), .B2(n1176), .O(n966)
         );
  ND2S U1295 ( .I1(n967), .I2(n966), .O(N710) );
  INV1S U1296 ( .I(map_f_1__1_), .O(n1390) );
  MOAI1S U1297 ( .A1(n1390), .A2(n1380), .B1(map_f_3__1_), .B2(n1355), .O(n971) );
  ND2S U1298 ( .I1(map_f_11__1_), .I2(n1417), .O(n969) );
  AOI22S U1299 ( .A1(map_f_9__1_), .A2(n1300), .B1(map_f_5__1_), .B2(n1337), 
        .O(n968) );
  ND3S U1300 ( .I1(n969), .I2(n968), .I3(n999), .O(n970) );
  AO112S U1301 ( .C1(map_f_7__1_), .C2(n1325), .A1(n971), .B1(n970), .O(n1002)
         );
  AOI22S U1302 ( .A1(n1202), .A2(n1002), .B1(n1200), .B2(n998), .O(n973) );
  AOI22S U1303 ( .A1(n1175), .A2(n1193), .B1(row_f[13]), .B2(n1176), .O(n972)
         );
  ND2S U1304 ( .I1(n973), .I2(n972), .O(N707) );
  INV1S U1305 ( .I(map_f_1__2_), .O(n1388) );
  MOAI1S U1306 ( .A1(n1388), .A2(n1380), .B1(map_f_3__2_), .B2(n1355), .O(n977) );
  ND2S U1307 ( .I1(map_f_11__2_), .I2(n1417), .O(n975) );
  AOI22S U1308 ( .A1(map_f_9__2_), .A2(n1300), .B1(map_f_5__2_), .B2(n1337), 
        .O(n974) );
  ND3S U1309 ( .I1(n975), .I2(n974), .I3(n1035), .O(n976) );
  AO112S U1310 ( .C1(map_f_7__2_), .C2(n1325), .A1(n977), .B1(n976), .O(n1040)
         );
  AOI22S U1311 ( .A1(n1202), .A2(n1040), .B1(n1200), .B2(n1033), .O(n979) );
  AOI22S U1312 ( .A1(n1175), .A2(n1189), .B1(row_f[14]), .B2(n1176), .O(n978)
         );
  ND2S U1313 ( .I1(n979), .I2(n978), .O(N708) );
  INV1S U1314 ( .I(map_f_1__5_), .O(n1382) );
  MOAI1S U1315 ( .A1(n1382), .A2(n1380), .B1(map_f_3__5_), .B2(n1355), .O(n983) );
  ND2S U1316 ( .I1(map_f_11__5_), .I2(n1417), .O(n981) );
  AOI22S U1317 ( .A1(map_f_9__5_), .A2(n1300), .B1(map_f_5__5_), .B2(n1337), 
        .O(n980) );
  ND3S U1318 ( .I1(n981), .I2(n980), .I3(n1006), .O(n982) );
  AO112S U1319 ( .C1(map_f_7__5_), .C2(n1325), .A1(n983), .B1(n982), .O(n1009)
         );
  AOI22S U1320 ( .A1(n1202), .A2(n1009), .B1(n1200), .B2(n1005), .O(n985) );
  AOI22S U1321 ( .A1(n1175), .A2(n1177), .B1(row_f[17]), .B2(n1176), .O(n984)
         );
  ND2S U1322 ( .I1(n985), .I2(n984), .O(N711) );
  INV1S U1323 ( .I(map_f_1__0_), .O(n1394) );
  MOAI1S U1324 ( .A1(n1394), .A2(n1380), .B1(map_f_3__0_), .B2(n1355), .O(n989) );
  ND2S U1325 ( .I1(map_f_11__0_), .I2(n1417), .O(n987) );
  AOI22S U1326 ( .A1(map_f_9__0_), .A2(n1300), .B1(map_f_5__0_), .B2(n1337), 
        .O(n986) );
  AO112S U1327 ( .C1(map_f_7__0_), .C2(n1325), .A1(n989), .B1(n988), .O(n1016)
         );
  AOI22S U1328 ( .A1(n1202), .A2(n1016), .B1(n1200), .B2(n1012), .O(n991) );
  AOI22S U1329 ( .A1(n1175), .A2(n1199), .B1(row_f[12]), .B2(n1176), .O(n990)
         );
  ND2S U1330 ( .I1(n991), .I2(n990), .O(N706) );
  INV1S U1331 ( .I(map_f_1__3_), .O(n1386) );
  MOAI1S U1332 ( .A1(n1386), .A2(n1380), .B1(map_f_3__3_), .B2(n1355), .O(n995) );
  ND2S U1333 ( .I1(map_f_11__3_), .I2(n1417), .O(n993) );
  AOI22S U1334 ( .A1(map_f_9__3_), .A2(n1300), .B1(map_f_5__3_), .B2(n1337), 
        .O(n992) );
  ND3S U1335 ( .I1(n993), .I2(n992), .I3(n1027), .O(n994) );
  AO112S U1336 ( .C1(map_f_7__3_), .C2(n1325), .A1(n995), .B1(n994), .O(n1030)
         );
  AOI22S U1337 ( .A1(n1202), .A2(n1030), .B1(n1200), .B2(n1026), .O(n997) );
  AOI22S U1338 ( .A1(n1175), .A2(n1185), .B1(row_f[15]), .B2(n1176), .O(n996)
         );
  ND2S U1339 ( .I1(n997), .I2(n996), .O(N709) );
  AOI22S U1340 ( .A1(n1034), .A2(n998), .B1(row_f[7]), .B2(n1176), .O(n1004)
         );
  AOI22S U1341 ( .A1(n1396), .A2(map_f_4__1_), .B1(map_f_0__1_), .B2(n1356), 
        .O(n1000) );
  OAI112HS U1342 ( .C1(n1319), .C2(n1037), .A1(n1000), .B1(n999), .O(n1001) );
  AOI22S U1343 ( .A1(n1041), .A2(n1002), .B1(n1039), .B2(n1001), .O(n1003) );
  ND2S U1344 ( .I1(n1004), .I2(n1003), .O(N701) );
  AOI22S U1345 ( .A1(n1034), .A2(n1005), .B1(row_f[11]), .B2(n1176), .O(n1011)
         );
  AOI22S U1346 ( .A1(n1396), .A2(map_f_4__5_), .B1(map_f_0__5_), .B2(n1356), 
        .O(n1007) );
  OAI112HS U1347 ( .C1(n1311), .C2(n1037), .A1(n1007), .B1(n1006), .O(n1008)
         );
  AOI22S U1348 ( .A1(n1041), .A2(n1009), .B1(n1039), .B2(n1008), .O(n1010) );
  ND2S U1349 ( .I1(n1011), .I2(n1010), .O(N705) );
  AOI22S U1350 ( .A1(n1034), .A2(n1012), .B1(row_f[6]), .B2(n1176), .O(n1018)
         );
  AOI22S U1351 ( .A1(n1396), .A2(map_f_4__0_), .B1(map_f_0__0_), .B2(n1356), 
        .O(n1014) );
  OAI112HS U1352 ( .C1(n1323), .C2(n1037), .A1(n1014), .B1(n1013), .O(n1015)
         );
  AOI22S U1353 ( .A1(n1041), .A2(n1016), .B1(n1039), .B2(n1015), .O(n1017) );
  ND2S U1354 ( .I1(n1018), .I2(n1017), .O(N700) );
  AOI22S U1355 ( .A1(n1034), .A2(n1019), .B1(row_f[10]), .B2(n1176), .O(n1025)
         );
  AOI22S U1356 ( .A1(n1396), .A2(map_f_4__4_), .B1(map_f_0__4_), .B2(n1356), 
        .O(n1021) );
  OAI112HS U1357 ( .C1(n1313), .C2(n1037), .A1(n1021), .B1(n1020), .O(n1022)
         );
  AOI22S U1358 ( .A1(n1041), .A2(n1023), .B1(n1039), .B2(n1022), .O(n1024) );
  ND2S U1359 ( .I1(n1025), .I2(n1024), .O(N704) );
  AOI22S U1360 ( .A1(n1034), .A2(n1026), .B1(row_f[9]), .B2(n1176), .O(n1032)
         );
  AOI22S U1361 ( .A1(n1396), .A2(map_f_4__3_), .B1(map_f_0__3_), .B2(n1356), 
        .O(n1028) );
  OAI112HS U1362 ( .C1(n1315), .C2(n1037), .A1(n1028), .B1(n1027), .O(n1029)
         );
  AOI22S U1363 ( .A1(n1041), .A2(n1030), .B1(n1039), .B2(n1029), .O(n1031) );
  ND2S U1364 ( .I1(n1032), .I2(n1031), .O(N703) );
  AOI22S U1365 ( .A1(n1034), .A2(n1033), .B1(row_f[8]), .B2(n1176), .O(n1043)
         );
  AOI22S U1366 ( .A1(n1396), .A2(map_f_4__2_), .B1(map_f_0__2_), .B2(n1356), 
        .O(n1036) );
  OAI112HS U1367 ( .C1(n1317), .C2(n1037), .A1(n1036), .B1(n1035), .O(n1038)
         );
  AOI22S U1368 ( .A1(n1041), .A2(n1040), .B1(n1039), .B2(n1038), .O(n1042) );
  ND2S U1369 ( .I1(n1043), .I2(n1042), .O(N702) );
  AOI22S U1370 ( .A1(n1248), .A2(n1468), .B1(tetrominoes_map_f[13]), .B2(n1236), .O(n1045) );
  AOI22S U1371 ( .A1(tetrominoes_map_f[12]), .A2(n1231), .B1(
        tetrominoes_map_f[19]), .B2(n1228), .O(n1044) );
  ND2S U1372 ( .I1(n1045), .I2(n1044), .O(n746) );
  ND2S U1373 ( .I1(n1055), .I2(n1046), .O(n1047) );
  AOI22S U1374 ( .A1(n1224), .A2(n1047), .B1(tetrominoes_map_f[13]), .B2(n1228), .O(n1049) );
  AOI22S U1375 ( .A1(n1231), .A2(tetrominoes_map_f[6]), .B1(
        tetrominoes_map_f[7]), .B2(n1236), .O(n1048) );
  ND2S U1376 ( .I1(n1049), .I2(n1048), .O(n740) );
  AOI22S U1377 ( .A1(n1224), .A2(n1050), .B1(tetrominoes_map_f[12]), .B2(n1236), .O(n1053) );
  MAOI1S U1378 ( .A1(tetrominoes_map_f[18]), .A2(n1228), .B1(n1219), .B2(n1051), .O(n1052) );
  ND2S U1379 ( .I1(n1053), .I2(n1052), .O(n747) );
  NR2 U1380 ( .I1(n1055), .I2(n1054), .O(bottom_0__0_) );
  NR3 U1381 ( .I1(tetrominoes[1]), .I2(n763), .I3(n1055), .O(bottom_1__0_) );
  AN2S U1382 ( .I1(n764), .I2(n1056), .O(bottom_2__0_) );
  INV1S U1383 ( .I(map_f_11__0_), .O(n1441) );
  INV1S U1384 ( .I(map_f_9__0_), .O(n1321) );
  ND3S U1385 ( .I1(n1441), .I2(n1443), .I3(n1321), .O(n1067) );
  NR2 U1386 ( .I1(map_f_7__0_), .I2(n1067), .O(n1064) );
  MOAI1S U1387 ( .A1(n1323), .A2(n1067), .B1(n1441), .B2(map_f_10__0_), .O(
        n1061) );
  NR2 U1388 ( .I1(map_f_6__0_), .I2(n1061), .O(n1060) );
  INV1S U1389 ( .I(map_f_3__0_), .O(n1366) );
  ND2S U1390 ( .I1(n1366), .I2(map_f_0__0_), .O(n1057) );
  INV1S U1391 ( .I(map_f_2__0_), .O(n1377) );
  OAI22S U1392 ( .A1(n1057), .A2(map_f_1__0_), .B1(map_f_3__0_), .B2(n1377), 
        .O(n1058) );
  INV1S U1393 ( .I(map_f_5__0_), .O(n1412) );
  OAI12HS U1394 ( .B1(map_f_4__0_), .B2(n1058), .A1(n1412), .O(n1059) );
  MOAI1S U1395 ( .A1(n1064), .A2(n1061), .B1(n1060), .B2(n1059), .O(n1063) );
  OR2B1S U1396 ( .I1(n1247), .B1(n1248), .O(n1291) );
  INV1S U1397 ( .I(n1291), .O(n1062) );
  NR2 U1398 ( .I1(n1470), .I2(n1062), .O(n1171) );
  MOAI1S U1399 ( .A1(n1063), .A2(n1249), .B1(col_top_f[0]), .B2(n1171), .O(
        col_top[0]) );
  INV1S U1400 ( .I(n1064), .O(n1065) );
  NR2 U1401 ( .I1(map_f_8__0_), .I2(n1065), .O(n1073) );
  INV1S U1402 ( .I(map_f_6__0_), .O(n1349) );
  OAI112HS U1403 ( .C1(map_f_2__0_), .C2(map_f_1__0_), .A1(n1414), .B1(n1366), 
        .O(n1066) );
  ND3S U1404 ( .I1(n1349), .I2(n1412), .I3(n1066), .O(n1068) );
  AOI22S U1405 ( .A1(n1073), .A2(n1068), .B1(n1441), .B2(n1067), .O(n1069) );
  MOAI1S U1406 ( .A1(n1069), .A2(n1249), .B1(n1171), .B2(col_top_f[1]), .O(
        col_top[1]) );
  ND2S U1407 ( .I1(n1414), .I2(n1366), .O(n1070) );
  OA13S U1408 ( .B1(map_f_6__0_), .B2(map_f_5__0_), .B3(n1070), .A1(n1073), 
        .O(n1071) );
  NR2 U1409 ( .I1(map_f_11__0_), .I2(n1071), .O(n1072) );
  MOAI1S U1410 ( .A1(n1072), .A2(n1249), .B1(n1171), .B2(col_top_f[2]), .O(
        col_top[2]) );
  MOAI1S U1411 ( .A1(n1073), .A2(n1249), .B1(col_top_f[3]), .B2(n1171), .O(
        col_top[3]) );
  INV1S U1412 ( .I(map_f_11__1_), .O(n1437) );
  ND2S U1413 ( .I1(n1437), .I2(map_f_8__1_), .O(n1074) );
  OAI22S U1414 ( .A1(n1074), .A2(map_f_9__1_), .B1(map_f_11__1_), .B2(n1438), 
        .O(n1081) );
  INV1S U1415 ( .I(map_f_3__1_), .O(n1364) );
  ND2S U1416 ( .I1(n1364), .I2(map_f_0__1_), .O(n1075) );
  INV1S U1417 ( .I(map_f_2__1_), .O(n1375) );
  OAI22S U1418 ( .A1(n1075), .A2(map_f_1__1_), .B1(map_f_3__1_), .B2(n1375), 
        .O(n1076) );
  NR2 U1419 ( .I1(map_f_4__1_), .I2(n1076), .O(n1077) );
  NR2 U1420 ( .I1(map_f_5__1_), .I2(n1077), .O(n1078) );
  NR2 U1421 ( .I1(map_f_6__1_), .I2(n1078), .O(n1079) );
  NR2 U1422 ( .I1(map_f_10__1_), .I2(map_f_9__1_), .O(n1085) );
  INV1S U1423 ( .I(map_f_7__1_), .O(n1332) );
  ND3S U1424 ( .I1(n1085), .I2(n1437), .I3(n1332), .O(n1083) );
  NR2 U1425 ( .I1(n1079), .I2(n1083), .O(n1080) );
  NR2 U1426 ( .I1(n1081), .I2(n1080), .O(n1082) );
  MOAI1S U1427 ( .A1(n1082), .A2(n1249), .B1(col_top_f[4]), .B2(n1171), .O(
        col_top[4]) );
  INV1S U1428 ( .I(map_f_6__1_), .O(n1347) );
  INV1S U1429 ( .I(map_f_5__1_), .O(n1409) );
  OAI112HS U1430 ( .C1(map_f_2__1_), .C2(map_f_1__1_), .A1(n1410), .B1(n1364), 
        .O(n1084) );
  OR2S U1431 ( .I1(n1083), .I2(map_f_8__1_), .O(n1092) );
  AOI13HS U1432 ( .B1(n1347), .B2(n1409), .B3(n1084), .A1(n1092), .O(n1087) );
  NR2 U1433 ( .I1(map_f_11__1_), .I2(n1085), .O(n1086) );
  NR2 U1434 ( .I1(n1087), .I2(n1086), .O(n1088) );
  MOAI1S U1435 ( .A1(n1088), .A2(n1249), .B1(col_top_f[5]), .B2(n1171), .O(
        col_top[5]) );
  NR2 U1436 ( .I1(map_f_4__1_), .I2(map_f_3__1_), .O(n1089) );
  AOI13HS U1437 ( .B1(n1089), .B2(n1347), .B3(n1409), .A1(n1092), .O(n1090) );
  NR2 U1438 ( .I1(map_f_11__1_), .I2(n1090), .O(n1091) );
  MOAI1S U1439 ( .A1(n1091), .A2(n1249), .B1(n1171), .B2(col_top_f[6]), .O(
        col_top[6]) );
  INV1S U1440 ( .I(n1092), .O(n1093) );
  MOAI1S U1441 ( .A1(n1093), .A2(n1249), .B1(col_top_f[7]), .B2(n1171), .O(
        col_top[7]) );
  INV1S U1442 ( .I(map_f_11__2_), .O(n1434) );
  INV1S U1443 ( .I(map_f_9__2_), .O(n1316) );
  ND3S U1444 ( .I1(n1434), .I2(n1435), .I3(n1316), .O(n1100) );
  NR2 U1445 ( .I1(map_f_7__2_), .I2(n1100), .O(n1110) );
  MOAI1S U1446 ( .A1(n1317), .A2(n1100), .B1(n1434), .B2(map_f_10__2_), .O(
        n1109) );
  NR2 U1447 ( .I1(map_f_6__2_), .I2(n1109), .O(n1097) );
  INV1S U1448 ( .I(map_f_3__2_), .O(n1363) );
  ND2S U1449 ( .I1(n1363), .I2(map_f_0__2_), .O(n1094) );
  INV1S U1450 ( .I(map_f_2__2_), .O(n1374) );
  OAI22S U1451 ( .A1(n1094), .A2(map_f_1__2_), .B1(map_f_3__2_), .B2(n1374), 
        .O(n1095) );
  INV1S U1452 ( .I(map_f_5__2_), .O(n1407) );
  OAI12HS U1453 ( .B1(map_f_4__2_), .B2(n1095), .A1(n1407), .O(n1096) );
  MOAI1S U1454 ( .A1(n1110), .A2(n1109), .B1(n1097), .B2(n1096), .O(n1098) );
  MOAI1S U1455 ( .A1(n1098), .A2(n1249), .B1(col_top_f[8]), .B2(n1171), .O(
        col_top[8]) );
  ND2S U1456 ( .I1(n1110), .I2(n1317), .O(n1105) );
  NR2 U1457 ( .I1(map_f_6__2_), .I2(map_f_5__2_), .O(n1099) );
  NR2 U1458 ( .I1(n1105), .I2(n1099), .O(n1107) );
  OAI112HS U1459 ( .C1(map_f_2__2_), .C2(map_f_1__2_), .A1(n1408), .B1(n1363), 
        .O(n1101) );
  MOAI1S U1460 ( .A1(n1101), .A2(n1105), .B1(n1434), .B2(n1100), .O(n1102) );
  NR2 U1461 ( .I1(n1107), .I2(n1102), .O(n1103) );
  MOAI1S U1462 ( .A1(n1103), .A2(n1249), .B1(col_top_f[9]), .B2(n1171), .O(
        col_top[9]) );
  NR2 U1463 ( .I1(map_f_4__2_), .I2(map_f_3__2_), .O(n1104) );
  NR2 U1464 ( .I1(n1105), .I2(n1104), .O(n1106) );
  NR3 U1465 ( .I1(map_f_11__2_), .I2(n1107), .I3(n1106), .O(n1108) );
  MOAI1S U1466 ( .A1(n1108), .A2(n1249), .B1(n1171), .B2(col_top_f[10]), .O(
        col_top[10]) );
  AN2B1S U1467 ( .I1(n1110), .B1(n1109), .O(n1111) );
  MOAI1S U1468 ( .A1(n1111), .A2(n1249), .B1(col_top_f[11]), .B2(n1171), .O(
        col_top[11]) );
  INV1S U1469 ( .I(map_f_11__3_), .O(n1431) );
  ND2S U1470 ( .I1(n1431), .I2(map_f_8__3_), .O(n1112) );
  OAI22S U1471 ( .A1(n1112), .A2(map_f_9__3_), .B1(map_f_11__3_), .B2(n1432), 
        .O(n1119) );
  INV1S U1472 ( .I(map_f_3__3_), .O(n1362) );
  ND2S U1473 ( .I1(n1362), .I2(map_f_0__3_), .O(n1113) );
  INV1S U1474 ( .I(map_f_2__3_), .O(n1373) );
  OAI22S U1475 ( .A1(n1113), .A2(map_f_1__3_), .B1(map_f_3__3_), .B2(n1373), 
        .O(n1114) );
  NR2 U1476 ( .I1(map_f_4__3_), .I2(n1114), .O(n1115) );
  NR2 U1477 ( .I1(map_f_5__3_), .I2(n1115), .O(n1116) );
  NR2 U1478 ( .I1(map_f_6__3_), .I2(n1116), .O(n1117) );
  NR2 U1479 ( .I1(map_f_10__3_), .I2(map_f_9__3_), .O(n1123) );
  INV1S U1480 ( .I(map_f_7__3_), .O(n1330) );
  ND3S U1481 ( .I1(n1123), .I2(n1431), .I3(n1330), .O(n1121) );
  NR2 U1482 ( .I1(n1117), .I2(n1121), .O(n1118) );
  NR2 U1483 ( .I1(n1119), .I2(n1118), .O(n1120) );
  MOAI1S U1484 ( .A1(n1120), .A2(n1249), .B1(col_top_f[12]), .B2(n1171), .O(
        col_top[12]) );
  INV1S U1485 ( .I(map_f_6__3_), .O(n1345) );
  INV1S U1486 ( .I(map_f_5__3_), .O(n1405) );
  OAI112HS U1487 ( .C1(map_f_2__3_), .C2(map_f_1__3_), .A1(n1406), .B1(n1362), 
        .O(n1122) );
  OR2S U1488 ( .I1(n1121), .I2(map_f_8__3_), .O(n1130) );
  AOI13HS U1489 ( .B1(n1345), .B2(n1405), .B3(n1122), .A1(n1130), .O(n1125) );
  NR2 U1490 ( .I1(map_f_11__3_), .I2(n1123), .O(n1124) );
  NR2 U1491 ( .I1(n1125), .I2(n1124), .O(n1126) );
  MOAI1S U1492 ( .A1(n1126), .A2(n1249), .B1(col_top_f[13]), .B2(n1171), .O(
        col_top[13]) );
  NR2 U1493 ( .I1(map_f_4__3_), .I2(map_f_3__3_), .O(n1127) );
  AOI13HS U1494 ( .B1(n1127), .B2(n1345), .B3(n1405), .A1(n1130), .O(n1128) );
  NR2 U1495 ( .I1(map_f_11__3_), .I2(n1128), .O(n1129) );
  MOAI1S U1496 ( .A1(n1129), .A2(n1249), .B1(col_top_f[14]), .B2(n1171), .O(
        col_top[14]) );
  INV1S U1497 ( .I(n1130), .O(n1131) );
  MOAI1S U1498 ( .A1(n1131), .A2(n1249), .B1(col_top_f[15]), .B2(n1171), .O(
        col_top[15]) );
  INV1S U1499 ( .I(map_f_11__4_), .O(n1428) );
  ND2S U1500 ( .I1(n1428), .I2(map_f_8__4_), .O(n1132) );
  OAI22S U1501 ( .A1(n1132), .A2(map_f_9__4_), .B1(map_f_11__4_), .B2(n1429), 
        .O(n1139) );
  INV1S U1502 ( .I(map_f_3__4_), .O(n1361) );
  ND2S U1503 ( .I1(n1361), .I2(map_f_0__4_), .O(n1133) );
  INV1S U1504 ( .I(map_f_2__4_), .O(n1372) );
  OAI22S U1505 ( .A1(n1133), .A2(map_f_1__4_), .B1(map_f_3__4_), .B2(n1372), 
        .O(n1134) );
  NR2 U1506 ( .I1(map_f_4__4_), .I2(n1134), .O(n1135) );
  NR2 U1507 ( .I1(map_f_5__4_), .I2(n1135), .O(n1136) );
  NR2 U1508 ( .I1(map_f_6__4_), .I2(n1136), .O(n1137) );
  NR2 U1509 ( .I1(map_f_10__4_), .I2(map_f_9__4_), .O(n1143) );
  INV1S U1510 ( .I(map_f_7__4_), .O(n1329) );
  ND3S U1511 ( .I1(n1143), .I2(n1428), .I3(n1329), .O(n1141) );
  NR2 U1512 ( .I1(n1137), .I2(n1141), .O(n1138) );
  NR2 U1513 ( .I1(n1139), .I2(n1138), .O(n1140) );
  MOAI1S U1514 ( .A1(n1140), .A2(n1249), .B1(col_top_f[16]), .B2(n1171), .O(
        col_top[16]) );
  INV1S U1515 ( .I(map_f_6__4_), .O(n1344) );
  INV1S U1516 ( .I(map_f_5__4_), .O(n1403) );
  OAI112HS U1517 ( .C1(map_f_2__4_), .C2(map_f_1__4_), .A1(n1404), .B1(n1361), 
        .O(n1142) );
  OR2S U1518 ( .I1(n1141), .I2(map_f_8__4_), .O(n1150) );
  AOI13HS U1519 ( .B1(n1344), .B2(n1403), .B3(n1142), .A1(n1150), .O(n1145) );
  NR2 U1520 ( .I1(map_f_11__4_), .I2(n1143), .O(n1144) );
  NR2 U1521 ( .I1(n1145), .I2(n1144), .O(n1146) );
  MOAI1S U1522 ( .A1(n1146), .A2(n1249), .B1(col_top_f[17]), .B2(n1171), .O(
        col_top[17]) );
  NR2 U1523 ( .I1(map_f_4__4_), .I2(map_f_3__4_), .O(n1147) );
  AOI13HS U1524 ( .B1(n1147), .B2(n1344), .B3(n1403), .A1(n1150), .O(n1148) );
  NR2 U1525 ( .I1(map_f_11__4_), .I2(n1148), .O(n1149) );
  MOAI1S U1526 ( .A1(n1149), .A2(n1249), .B1(col_top_f[18]), .B2(n1171), .O(
        col_top[18]) );
  INV1S U1527 ( .I(n1150), .O(n1151) );
  MOAI1S U1528 ( .A1(n1151), .A2(n1249), .B1(col_top_f[19]), .B2(n1171), .O(
        col_top[19]) );
  INV1S U1529 ( .I(map_f_11__5_), .O(n1425) );
  ND2S U1530 ( .I1(n1425), .I2(map_f_8__5_), .O(n1152) );
  OAI22S U1531 ( .A1(n1152), .A2(map_f_9__5_), .B1(map_f_11__5_), .B2(n1426), 
        .O(n1159) );
  INV1S U1532 ( .I(map_f_3__5_), .O(n1360) );
  ND2S U1533 ( .I1(n1360), .I2(map_f_0__5_), .O(n1153) );
  INV1S U1534 ( .I(map_f_2__5_), .O(n1371) );
  OAI22S U1535 ( .A1(n1153), .A2(map_f_1__5_), .B1(map_f_3__5_), .B2(n1371), 
        .O(n1154) );
  NR2 U1536 ( .I1(map_f_4__5_), .I2(n1154), .O(n1155) );
  NR2 U1537 ( .I1(map_f_5__5_), .I2(n1155), .O(n1156) );
  NR2 U1538 ( .I1(map_f_6__5_), .I2(n1156), .O(n1157) );
  NR2 U1539 ( .I1(map_f_10__5_), .I2(map_f_9__5_), .O(n1163) );
  INV1S U1540 ( .I(map_f_7__5_), .O(n1328) );
  NR2 U1541 ( .I1(n1157), .I2(n1161), .O(n1158) );
  NR2 U1542 ( .I1(n1159), .I2(n1158), .O(n1160) );
  MOAI1S U1543 ( .A1(n1160), .A2(n1249), .B1(col_top_f[20]), .B2(n1171), .O(
        col_top[20]) );
  INV1S U1544 ( .I(map_f_6__5_), .O(n1343) );
  INV1S U1545 ( .I(map_f_5__5_), .O(n1401) );
  OAI112HS U1546 ( .C1(map_f_2__5_), .C2(map_f_1__5_), .A1(n1402), .B1(n1360), 
        .O(n1162) );
  OR2S U1547 ( .I1(n1161), .I2(map_f_8__5_), .O(n1170) );
  AOI13HS U1548 ( .B1(n1343), .B2(n1401), .B3(n1162), .A1(n1170), .O(n1165) );
  NR2 U1549 ( .I1(map_f_11__5_), .I2(n1163), .O(n1164) );
  NR2 U1550 ( .I1(n1165), .I2(n1164), .O(n1166) );
  MOAI1S U1551 ( .A1(n1166), .A2(n1249), .B1(col_top_f[21]), .B2(n1171), .O(
        col_top[21]) );
  NR2 U1552 ( .I1(map_f_4__5_), .I2(map_f_3__5_), .O(n1167) );
  AOI13HS U1553 ( .B1(n1167), .B2(n1343), .B3(n1401), .A1(n1170), .O(n1168) );
  NR2 U1554 ( .I1(map_f_11__5_), .I2(n1168), .O(n1169) );
  MOAI1S U1555 ( .A1(n1169), .A2(n1249), .B1(col_top_f[22]), .B2(n1171), .O(
        col_top[22]) );
  INV1S U1556 ( .I(n1170), .O(n1172) );
  MOAI1S U1557 ( .A1(n1172), .A2(n1249), .B1(col_top_f[23]), .B2(n1171), .O(
        col_top[23]) );
  INV1S U1558 ( .I(n1469), .O(n1173) );
  INV1S U1559 ( .I(map_f_0__0_), .O(n1392) );
  NR2 U1560 ( .I1(n1173), .I2(n1392), .O(tetris_comb[0]) );
  INV1S U1561 ( .I(map_f_0__1_), .O(n1389) );
  NR2 U1562 ( .I1(n1173), .I2(n1389), .O(tetris_comb[1]) );
  INV1S U1563 ( .I(map_f_0__2_), .O(n1387) );
  NR2 U1564 ( .I1(n1173), .I2(n1387), .O(tetris_comb[2]) );
  INV1S U1565 ( .I(map_f_0__3_), .O(n1385) );
  NR2 U1566 ( .I1(n1173), .I2(n1385), .O(tetris_comb[3]) );
  INV1S U1567 ( .I(map_f_0__4_), .O(n1383) );
  NR2 U1568 ( .I1(n1173), .I2(n1383), .O(tetris_comb[4]) );
  INV1S U1569 ( .I(map_f_0__5_), .O(n1381) );
  NR2 U1570 ( .I1(n1173), .I2(n1381), .O(tetris_comb[5]) );
  BUF1 U1571 ( .I(n1173), .O(n1174) );
  NR2 U1572 ( .I1(n1174), .I2(n1394), .O(tetris_comb[6]) );
  NR2 U1573 ( .I1(n1174), .I2(n1390), .O(tetris_comb[7]) );
  NR2 U1574 ( .I1(n1173), .I2(n1388), .O(tetris_comb[8]) );
  NR2 U1575 ( .I1(n1173), .I2(n1386), .O(tetris_comb[9]) );
  NR2 U1576 ( .I1(n1174), .I2(n1384), .O(tetris_comb[10]) );
  NR2 U1577 ( .I1(n1174), .I2(n1382), .O(tetris_comb[11]) );
  NR2 U1578 ( .I1(n1174), .I2(n1377), .O(tetris_comb[12]) );
  NR2 U1579 ( .I1(n1174), .I2(n1375), .O(tetris_comb[13]) );
  NR2 U1580 ( .I1(n1174), .I2(n1374), .O(tetris_comb[14]) );
  NR2 U1581 ( .I1(n1174), .I2(n1373), .O(tetris_comb[15]) );
  NR2 U1582 ( .I1(n1174), .I2(n1372), .O(tetris_comb[16]) );
  NR2 U1583 ( .I1(n1174), .I2(n1371), .O(tetris_comb[17]) );
  NR2 U1584 ( .I1(n1174), .I2(n1366), .O(tetris_comb[18]) );
  NR2 U1585 ( .I1(n1174), .I2(n1364), .O(tetris_comb[19]) );
  NR2 U1586 ( .I1(n1174), .I2(n1363), .O(tetris_comb[20]) );
  NR2 U1587 ( .I1(n1174), .I2(n1362), .O(tetris_comb[21]) );
  NR2 U1588 ( .I1(n1173), .I2(n1361), .O(tetris_comb[22]) );
  NR2 U1589 ( .I1(n1173), .I2(n1360), .O(tetris_comb[23]) );
  NR2 U1590 ( .I1(n1173), .I2(n1414), .O(tetris_comb[24]) );
  NR2 U1591 ( .I1(n1174), .I2(n1410), .O(tetris_comb[25]) );
  NR2 U1592 ( .I1(n1173), .I2(n1408), .O(tetris_comb[26]) );
  NR2 U1593 ( .I1(n1174), .I2(n1406), .O(tetris_comb[27]) );
  NR2 U1594 ( .I1(n1173), .I2(n1404), .O(tetris_comb[28]) );
  NR2 U1595 ( .I1(n1173), .I2(n1402), .O(tetris_comb[29]) );
  NR2 U1596 ( .I1(n1174), .I2(n1412), .O(tetris_comb[30]) );
  NR2 U1597 ( .I1(n1174), .I2(n1409), .O(tetris_comb[31]) );
  NR2 U1598 ( .I1(n1174), .I2(n1407), .O(tetris_comb[32]) );
  NR2 U1599 ( .I1(n1174), .I2(n1405), .O(tetris_comb[33]) );
  NR2 U1600 ( .I1(n1174), .I2(n1403), .O(tetris_comb[34]) );
  NR2 U1601 ( .I1(n1174), .I2(n1401), .O(tetris_comb[35]) );
  NR2 U1602 ( .I1(n1174), .I2(n1349), .O(tetris_comb[36]) );
  NR2 U1603 ( .I1(n1174), .I2(n1347), .O(tetris_comb[37]) );
  INV1S U1604 ( .I(map_f_6__2_), .O(n1346) );
  NR2 U1605 ( .I1(n1174), .I2(n1346), .O(tetris_comb[38]) );
  NR2 U1606 ( .I1(n1174), .I2(n1345), .O(tetris_comb[39]) );
  NR2 U1607 ( .I1(n1173), .I2(n1344), .O(tetris_comb[40]) );
  NR2 U1608 ( .I1(n1174), .I2(n1343), .O(tetris_comb[41]) );
  INV1S U1609 ( .I(map_f_7__0_), .O(n1334) );
  NR2 U1610 ( .I1(n1173), .I2(n1334), .O(tetris_comb[42]) );
  NR2 U1611 ( .I1(n1173), .I2(n1332), .O(tetris_comb[43]) );
  INV1S U1612 ( .I(map_f_7__2_), .O(n1331) );
  NR2 U1613 ( .I1(n1173), .I2(n1331), .O(tetris_comb[44]) );
  NR2 U1614 ( .I1(n1173), .I2(n1330), .O(tetris_comb[45]) );
  NR2 U1615 ( .I1(n1173), .I2(n1329), .O(tetris_comb[46]) );
  NR2 U1616 ( .I1(n1173), .I2(n1328), .O(tetris_comb[47]) );
  NR2 U1617 ( .I1(n1174), .I2(n1323), .O(tetris_comb[48]) );
  NR2 U1618 ( .I1(n1173), .I2(n1319), .O(tetris_comb[49]) );
  NR2 U1619 ( .I1(n1173), .I2(n1317), .O(tetris_comb[50]) );
  NR2 U1620 ( .I1(n1173), .I2(n1315), .O(tetris_comb[51]) );
  NR2 U1621 ( .I1(n1174), .I2(n1313), .O(tetris_comb[52]) );
  NR2 U1622 ( .I1(n1174), .I2(n1311), .O(tetris_comb[53]) );
  NR2 U1623 ( .I1(n1173), .I2(n1321), .O(tetris_comb[54]) );
  INV1S U1624 ( .I(map_f_9__1_), .O(n1318) );
  NR2 U1625 ( .I1(n1173), .I2(n1318), .O(tetris_comb[55]) );
  NR2 U1626 ( .I1(n1173), .I2(n1316), .O(tetris_comb[56]) );
  INV1S U1627 ( .I(map_f_9__3_), .O(n1314) );
  NR2 U1628 ( .I1(n1174), .I2(n1314), .O(tetris_comb[57]) );
  INV1S U1629 ( .I(map_f_9__4_), .O(n1312) );
  NR2 U1630 ( .I1(n1174), .I2(n1312), .O(tetris_comb[58]) );
  INV1S U1631 ( .I(map_f_9__5_), .O(n1310) );
  NR2 U1632 ( .I1(n1173), .I2(n1310), .O(tetris_comb[59]) );
  NR2 U1633 ( .I1(n1174), .I2(n1443), .O(tetris_comb[60]) );
  NR2 U1634 ( .I1(n1174), .I2(n1438), .O(tetris_comb[61]) );
  NR2 U1635 ( .I1(n1174), .I2(n1435), .O(tetris_comb[62]) );
  NR2 U1636 ( .I1(n1174), .I2(n1432), .O(tetris_comb[63]) );
  NR2 U1637 ( .I1(n1174), .I2(n1429), .O(tetris_comb[64]) );
  NR2 U1638 ( .I1(n1174), .I2(n1426), .O(tetris_comb[65]) );
  NR2 U1639 ( .I1(n1173), .I2(n1441), .O(tetris_comb[66]) );
  NR2 U1640 ( .I1(n1174), .I2(n1437), .O(tetris_comb[67]) );
  NR2 U1641 ( .I1(n1174), .I2(n1434), .O(tetris_comb[68]) );
  NR2 U1642 ( .I1(n1174), .I2(n1431), .O(tetris_comb[69]) );
  NR2 U1643 ( .I1(n1174), .I2(n1428), .O(tetris_comb[70]) );
  NR2 U1644 ( .I1(n1174), .I2(n1425), .O(tetris_comb[71]) );
  INV1S U1645 ( .I(score_f[0]), .O(n1448) );
  NR2 U1646 ( .I1(n1249), .I2(n1448), .O(score_comb[0]) );
  AN2S U1647 ( .I1(n1470), .I2(score_f[1]), .O(score_comb[1]) );
  INV1S U1648 ( .I(score_f[2]), .O(n1455) );
  NR2 U1649 ( .I1(n1249), .I2(n1455), .O(score_comb[2]) );
  AN2S U1650 ( .I1(n1470), .I2(score_f[3]), .O(score_comb[3]) );
  ND2S U1651 ( .I1(N964), .I2(n1175), .O(n1205) );
  NR2 U1652 ( .I1(n1252), .I2(n1176), .O(n1198) );
  ND2S U1653 ( .I1(n1424), .I2(n1356), .O(n1354) );
  NR2 U1654 ( .I1(n1354), .I2(n1176), .O(n1197) );
  AOI22S U1655 ( .A1(map_f_10__5_), .A2(n1198), .B1(map_f_6__5_), .B2(n1197), 
        .O(n1180) );
  AOI22S U1656 ( .A1(n1202), .A2(n1178), .B1(n1200), .B2(n1177), .O(n1179) );
  OAI112HS U1657 ( .C1(n1292), .C2(n1205), .A1(n1180), .B1(n1179), .O(N723) );
  AOI22S U1658 ( .A1(map_f_10__4_), .A2(n1198), .B1(map_f_6__4_), .B2(n1197), 
        .O(n1184) );
  AOI22S U1659 ( .A1(n1202), .A2(n1182), .B1(n1200), .B2(n1181), .O(n1183) );
  OAI112HS U1660 ( .C1(n1293), .C2(n1205), .A1(n1184), .B1(n1183), .O(N722) );
  AOI22S U1661 ( .A1(map_f_10__3_), .A2(n1198), .B1(map_f_6__3_), .B2(n1197), 
        .O(n1188) );
  AOI22S U1662 ( .A1(n1202), .A2(n1186), .B1(n1200), .B2(n1185), .O(n1187) );
  OAI112HS U1663 ( .C1(n1294), .C2(n1205), .A1(n1188), .B1(n1187), .O(N721) );
  AOI22S U1664 ( .A1(map_f_10__2_), .A2(n1198), .B1(map_f_6__2_), .B2(n1197), 
        .O(n1192) );
  AOI22S U1665 ( .A1(n1202), .A2(n1190), .B1(n1200), .B2(n1189), .O(n1191) );
  OAI112HS U1666 ( .C1(n1295), .C2(n1205), .A1(n1192), .B1(n1191), .O(N720) );
  AOI22S U1667 ( .A1(map_f_10__1_), .A2(n1198), .B1(map_f_6__1_), .B2(n1197), 
        .O(n1196) );
  AOI22S U1668 ( .A1(n1202), .A2(n1194), .B1(n1200), .B2(n1193), .O(n1195) );
  OAI112HS U1669 ( .C1(n1296), .C2(n1205), .A1(n1196), .B1(n1195), .O(N719) );
  AOI22S U1670 ( .A1(map_f_10__0_), .A2(n1198), .B1(map_f_6__0_), .B2(n1197), 
        .O(n1204) );
  AOI22S U1671 ( .A1(n1202), .A2(n1201), .B1(n1200), .B2(n1199), .O(n1203) );
  OAI112HS U1672 ( .C1(n1299), .C2(n1205), .A1(n1204), .B1(n1203), .O(N718) );
  AOI13HS U1673 ( .B1(n1246), .B2(n1482), .B3(n763), .A1(state[0]), .O(
        next_state_0_) );
  ND2S U1674 ( .I1(n1215), .I2(cnt_f[0]), .O(n1206) );
  OAI22S U1675 ( .A1(n1471), .A2(n1206), .B1(n1215), .B2(cnt_f[0]), .O(cnt[0])
         );
  ND2S U1676 ( .I1(cnt_f[0]), .I2(n1224), .O(n1208) );
  ND2S U1677 ( .I1(n1208), .I2(n1210), .O(n1207) );
  AOI22S U1678 ( .A1(cnt_f[1]), .A2(n1207), .B1(n1208), .B2(n1209), .O(cnt[1])
         );
  NR2 U1679 ( .I1(n1209), .I2(n1208), .O(n1213) );
  INV1S U1680 ( .I(n1213), .O(n1211) );
  ND2S U1681 ( .I1(n1211), .I2(n1210), .O(n1214) );
  OAI22S U1682 ( .A1(n1212), .A2(n1214), .B1(cnt_f[2]), .B2(n1211), .O(cnt[2])
         );
  ND2S U1683 ( .I1(cnt_f[2]), .I2(n1213), .O(n1217) );
  OAI12HS U1684 ( .B1(cnt_f[2]), .B2(n1215), .A1(n1214), .O(n1216) );
  MOAI1S U1685 ( .A1(cnt_f[3]), .A2(n1217), .B1(cnt_f[3]), .B2(n1216), .O(
        cnt[3]) );
  MOAI1S U1686 ( .A1(n1219), .A2(n1218), .B1(n1236), .B2(tetrominoes_map_f[18]), .O(n753) );
  AO22S U1687 ( .A1(tetrominoes_map_f[18]), .A2(n1231), .B1(
        tetrominoes_map_f[19]), .B2(n1236), .O(n752) );
  AO222S U1688 ( .A1(n1231), .A2(tetrominoes_map_f[19]), .B1(
        tetrominoes_map_f[20]), .B2(n1236), .C1(tetrominoes_map_f[18]), .C2(
        n1229), .O(n751) );
  AO222S U1689 ( .A1(tetrominoes_map_f[0]), .A2(n1236), .B1(
        tetrominoes_map_f[6]), .B2(n1228), .C1(n1224), .C2(n1220), .O(n735) );
  ND2S U1690 ( .I1(tetrominoes_map_f[8]), .I2(n1228), .O(n1226) );
  AOI22S U1691 ( .A1(tetrominoes_map_f[2]), .A2(n1236), .B1(
        tetrominoes_map_f[1]), .B2(n1231), .O(n1225) );
  NR2 U1692 ( .I1(tetrominoes[0]), .I2(n1221), .O(n1223) );
  ND3S U1693 ( .I1(n1224), .I2(n1223), .I3(n1222), .O(n1232) );
  ND3S U1694 ( .I1(n1226), .I2(n1225), .I3(n1232), .O(n1227) );
  AO12S U1695 ( .B1(tetrominoes_map_f[0]), .B2(n1229), .A1(n1227), .O(n733) );
  AOI22S U1696 ( .A1(n1229), .A2(tetrominoes_map_f[1]), .B1(
        tetrominoes_map_f[9]), .B2(n1228), .O(n1234) );
  AOI22S U1697 ( .A1(tetrominoes_map_f[2]), .A2(n1231), .B1(
        tetrominoes_map_f[0]), .B2(n1230), .O(n1233) );
  AO12S U1698 ( .B1(tetrominoes_map_f[3]), .B2(n1236), .A1(n1235), .O(n732) );
  INV1S U1699 ( .I(bottom_f[2]), .O(intadd_3_A_1_) );
  AOI22S U1700 ( .A1(n1238), .A2(col_top_f[13]), .B1(col_top_f[21]), .B2(n1237), .O(n1243) );
  AOI22S U1701 ( .A1(n1240), .A2(col_top_f[17]), .B1(n1239), .B2(col_top_f[9]), 
        .O(n1242) );
  AOI22S U1702 ( .A1(n1257), .A2(col_top_f[1]), .B1(n1256), .B2(col_top_f[5]), 
        .O(n1241) );
  AN3S U1703 ( .I1(n1243), .I2(n1242), .I3(n1241), .O(intadd_3_B_0_) );
  NR2 U1704 ( .I1(n1245), .I2(n1244), .O(intadd_3_CI) );
  INV1S U1705 ( .I(intadd_3_B_1_), .O(intadd_3_A_2_) );
  INV1S U1706 ( .I(n1447), .O(n1449) );
  ND2S U1707 ( .I1(n1449), .I2(n1339), .O(n1254) );
  AOI22S U1708 ( .A1(n1248), .A2(n1247), .B1(n1246), .B2(n1472), .O(n1250) );
  ND2S U1709 ( .I1(n1250), .I2(n1249), .O(n1454) );
  NR2 U1710 ( .I1(n1453), .I2(n1456), .O(n1446) );
  OA12S U1711 ( .B1(n1419), .B2(n1418), .A1(n1339), .O(n1326) );
  MOAI1S U1712 ( .A1(n1456), .A2(n1339), .B1(n1446), .B2(n1326), .O(n1251) );
  NR2 U1713 ( .I1(n1454), .I2(n1251), .O(n1253) );
  ND2S U1714 ( .I1(n1446), .I2(n1287), .O(n1444) );
  OAI222S U1715 ( .A1(n1254), .A2(n1323), .B1(n1334), .B2(n1253), .C1(n1252), 
        .C2(n1444), .O(n728) );
  ND2S U1716 ( .I1(n1446), .I2(n1286), .O(n1439) );
  OAI222S U1717 ( .A1(n1254), .A2(n1319), .B1(n1332), .B2(n1253), .C1(n1252), 
        .C2(n1439), .O(n727) );
  INV1S U1718 ( .I(n1446), .O(n1398) );
  OR2S U1719 ( .I1(n1398), .I2(n1284), .O(n1436) );
  OAI222S U1720 ( .A1(n1254), .A2(n1317), .B1(n1331), .B2(n1253), .C1(n1252), 
        .C2(n1436), .O(n726) );
  OR2S U1721 ( .I1(n1398), .I2(n1283), .O(n1433) );
  OAI222S U1722 ( .A1(n1254), .A2(n1315), .B1(n1330), .B2(n1253), .C1(n1252), 
        .C2(n1433), .O(n725) );
  OR2S U1723 ( .I1(n1398), .I2(n1282), .O(n1430) );
  OAI222S U1724 ( .A1(n1254), .A2(n1313), .B1(n1329), .B2(n1253), .C1(n1252), 
        .C2(n1430), .O(n724) );
  OR2S U1725 ( .I1(n1398), .I2(n1255), .O(n1427) );
  OAI222S U1726 ( .A1(n1254), .A2(n1311), .B1(n1328), .B2(n1253), .C1(n1252), 
        .C2(n1427), .O(n7230) );
  INV1S U1727 ( .I(n1309), .O(n1340) );
  ND3S U1728 ( .I1(n1473), .I2(n1290), .I3(n1340), .O(n1285) );
  ND2S U1729 ( .I1(n1291), .I2(n1285), .O(n1289) );
  OAI22S U1730 ( .A1(n1255), .A2(n1285), .B1(n1289), .B2(n1292), .O(n7220) );
  AOI22S U1731 ( .A1(n1257), .A2(col_top_f[12]), .B1(col_top_f[16]), .B2(n1256), .O(n1258) );
  OAI12HS U1732 ( .B1(n1260), .B2(n1259), .A1(n1258), .O(n1262) );
  MOAI1S U1733 ( .A1(n1263), .A2(n1262), .B1(n1263), .B2(n1261), .O(n1265) );
  MOAI1S U1734 ( .A1(n1269), .A2(n1265), .B1(n1269), .B2(n1264), .O(n1266) );
  AOI22S U1735 ( .A1(n1473), .A2(n1416), .B1(n1267), .B2(n1266), .O(n1268) );
  MOAI1S U1736 ( .A1(n1280), .A2(n1268), .B1(n1280), .B2(bottom_compare_f[0]), 
        .O(n7210) );
  INV1S U1737 ( .I(n1269), .O(n1272) );
  MOAI1S U1738 ( .A1(n1272), .A2(n1271), .B1(n1272), .B2(n1270), .O(n1274) );
  INV1S U1739 ( .I(n1280), .O(n1273) );
  OAI12HS U1740 ( .B1(n1275), .B2(n1274), .A1(n1273), .O(n1278) );
  AOI13HS U1741 ( .B1(n1473), .B2(bottom_compare_f[0]), .B3(n1276), .A1(n1278), 
        .O(n1281) );
  ND2S U1742 ( .I1(n1473), .I2(n1416), .O(n1277) );
  OR2B1S U1743 ( .I1(n1278), .B1(n1277), .O(n1279) );
  MOAI1S U1744 ( .A1(n1281), .A2(n1280), .B1(bottom_compare_f[1]), .B2(n1279), 
        .O(n7200) );
  OAI22S U1745 ( .A1(n1282), .A2(n1285), .B1(n1289), .B2(n1293), .O(n7180) );
  OAI22S U1746 ( .A1(n1283), .A2(n1285), .B1(n1289), .B2(n1294), .O(n7170) );
  OAI22S U1747 ( .A1(n1284), .A2(n1285), .B1(n1289), .B2(n1295), .O(n7160) );
  INV1S U1748 ( .I(n1285), .O(n1288) );
  MOAI1S U1749 ( .A1(n1289), .A2(n1296), .B1(n1288), .B2(n1286), .O(n7150) );
  MOAI1S U1750 ( .A1(n1289), .A2(n1299), .B1(n1288), .B2(n1287), .O(n7140) );
  OR2S U1751 ( .I1(n1447), .I2(n1290), .O(n1423) );
  ND2S U1752 ( .I1(n1307), .I2(n1424), .O(n1297) );
  OAI112HS U1753 ( .C1(n1456), .C2(n1297), .A1(n1423), .B1(n1291), .O(n1298)
         );
  OAI222S U1754 ( .A1(n1292), .A2(n1423), .B1(n1298), .B2(n1425), .C1(n1297), 
        .C2(n1427), .O(n7130) );
  OAI222S U1755 ( .A1(n1293), .A2(n1423), .B1(n1298), .B2(n1428), .C1(n1297), 
        .C2(n1430), .O(n7120) );
  OAI222S U1756 ( .A1(n1294), .A2(n1423), .B1(n1298), .B2(n1431), .C1(n1297), 
        .C2(n1433), .O(n7110) );
  OAI222S U1757 ( .A1(n1295), .A2(n1423), .B1(n1298), .B2(n1434), .C1(n1297), 
        .C2(n1436), .O(n7100) );
  OAI222S U1758 ( .A1(n1296), .A2(n1423), .B1(n1298), .B2(n1437), .C1(n1297), 
        .C2(n1439), .O(n7090) );
  OAI222S U1759 ( .A1(n1299), .A2(n1423), .B1(n1298), .B2(n1441), .C1(n1297), 
        .C2(n1444), .O(n7080) );
  ND2S U1760 ( .I1(bottom_compare_f[0]), .I2(n1300), .O(n1306) );
  INV1S U1761 ( .I(n1301), .O(n1303) );
  NR2 U1762 ( .I1(n1398), .I2(n1301), .O(n1420) );
  MOAI1S U1763 ( .A1(n1456), .A2(n1303), .B1(n1306), .B2(n1420), .O(n1302) );
  NR2 U1764 ( .I1(n1454), .I2(n1302), .O(n1305) );
  ND2S U1765 ( .I1(n1449), .I2(n1303), .O(n1304) );
  OAI222S U1766 ( .A1(n1427), .A2(n1306), .B1(n1310), .B2(n1305), .C1(n1426), 
        .C2(n1304), .O(n7070) );
  OAI222S U1767 ( .A1(n1430), .A2(n1306), .B1(n1312), .B2(n1305), .C1(n1429), 
        .C2(n1304), .O(n7060) );
  OAI222S U1768 ( .A1(n1433), .A2(n1306), .B1(n1314), .B2(n1305), .C1(n1432), 
        .C2(n1304), .O(n7050) );
  OAI222S U1769 ( .A1(n1436), .A2(n1306), .B1(n1316), .B2(n1305), .C1(n1435), 
        .C2(n1304), .O(n7040) );
  OAI222S U1770 ( .A1(n1439), .A2(n1306), .B1(n1318), .B2(n1305), .C1(n1438), 
        .C2(n1304), .O(n7030) );
  OAI222S U1771 ( .A1(n1444), .A2(n1306), .B1(n1321), .B2(n1305), .C1(n1443), 
        .C2(n1304), .O(n7020) );
  ND2S U1772 ( .I1(n1307), .I2(n1340), .O(n1324) );
  ND2S U1773 ( .I1(n1339), .I2(n1398), .O(n1308) );
  AOI13HS U1774 ( .B1(n1473), .B2(n1324), .B3(n1308), .A1(n1454), .O(n1322) );
  AO12S U1775 ( .B1(N964), .B2(n1309), .A1(n1423), .O(n1320) );
  OAI222S U1776 ( .A1(n1324), .A2(n1427), .B1(n1311), .B2(n1322), .C1(n1310), 
        .C2(n1320), .O(n7010) );
  OAI222S U1777 ( .A1(n1324), .A2(n1430), .B1(n1313), .B2(n1322), .C1(n1312), 
        .C2(n1320), .O(n7000) );
  OAI222S U1778 ( .A1(n1324), .A2(n1433), .B1(n1315), .B2(n1322), .C1(n1314), 
        .C2(n1320), .O(n699) );
  OAI222S U1779 ( .A1(n1324), .A2(n1436), .B1(n1317), .B2(n1322), .C1(n1316), 
        .C2(n1320), .O(n698) );
  OAI222S U1780 ( .A1(n1324), .A2(n1439), .B1(n1319), .B2(n1322), .C1(n1318), 
        .C2(n1320), .O(n697) );
  OAI222S U1781 ( .A1(n1324), .A2(n1444), .B1(n1323), .B2(n1322), .C1(n1321), 
        .C2(n1320), .O(n696) );
  ND2S U1782 ( .I1(n1325), .I2(n1416), .O(n1336) );
  AO12S U1783 ( .B1(bottom_compare_f[1]), .B2(bottom_compare_f[2]), .A1(N964), 
        .O(n1338) );
  OAI22S U1784 ( .A1(n1326), .A2(n1456), .B1(n1398), .B2(n1338), .O(n1327) );
  NR2 U1785 ( .I1(n1454), .I2(n1327), .O(n1335) );
  AO12S U1786 ( .B1(n1336), .B2(n1338), .A1(n1447), .O(n1333) );
  OAI222S U1787 ( .A1(n1336), .A2(n1427), .B1(n1343), .B2(n1335), .C1(n1328), 
        .C2(n1333), .O(n695) );
  OAI222S U1788 ( .A1(n1336), .A2(n1430), .B1(n1344), .B2(n1335), .C1(n1329), 
        .C2(n1333), .O(n694) );
  OAI222S U1789 ( .A1(n1336), .A2(n1433), .B1(n1345), .B2(n1335), .C1(n1330), 
        .C2(n1333), .O(n693) );
  OAI222S U1790 ( .A1(n1336), .A2(n1436), .B1(n1346), .B2(n1335), .C1(n1331), 
        .C2(n1333), .O(n692) );
  OAI222S U1791 ( .A1(n1336), .A2(n1439), .B1(n1347), .B2(n1335), .C1(n1332), 
        .C2(n1333), .O(n691) );
  OAI222S U1792 ( .A1(n1336), .A2(n1444), .B1(n1349), .B2(n1335), .C1(n1334), 
        .C2(n1333), .O(n690) );
  ND2S U1793 ( .I1(bottom_compare_f[0]), .I2(n1337), .O(n1351) );
  INV1S U1794 ( .I(n1338), .O(n1342) );
  OA12S U1795 ( .B1(n1340), .B2(n1419), .A1(n1339), .O(n1400) );
  MOAI1S U1796 ( .A1(n1456), .A2(n1342), .B1(n1446), .B2(n1400), .O(n1341) );
  NR2 U1797 ( .I1(n1454), .I2(n1341), .O(n1350) );
  ND2S U1798 ( .I1(n1449), .I2(n1342), .O(n1348) );
  OAI222S U1799 ( .A1(n1351), .A2(n1427), .B1(n1401), .B2(n1350), .C1(n1343), 
        .C2(n1348), .O(n689) );
  OAI222S U1800 ( .A1(n1351), .A2(n1430), .B1(n1403), .B2(n1350), .C1(n1344), 
        .C2(n1348), .O(n688) );
  OAI222S U1801 ( .A1(n1351), .A2(n1433), .B1(n1405), .B2(n1350), .C1(n1345), 
        .C2(n1348), .O(n687) );
  OAI222S U1802 ( .A1(n1351), .A2(n1436), .B1(n1407), .B2(n1350), .C1(n1346), 
        .C2(n1348), .O(n686) );
  OAI222S U1803 ( .A1(n1351), .A2(n1439), .B1(n1409), .B2(n1350), .C1(n1347), 
        .C2(n1348), .O(n685) );
  OAI222S U1804 ( .A1(n1351), .A2(n1444), .B1(n1412), .B2(n1350), .C1(n1349), 
        .C2(n1348), .O(n684) );
  ND2S U1805 ( .I1(n1356), .I2(n1398), .O(n1352) );
  AOI13HS U1806 ( .B1(n1473), .B2(n1354), .B3(n1352), .A1(n1454), .O(n1353) );
  ND2S U1807 ( .I1(n1449), .I2(n1356), .O(n1359) );
  OAI222S U1808 ( .A1(n1354), .A2(n1427), .B1(n1360), .B2(n1353), .C1(n1402), 
        .C2(n1359), .O(n683) );
  OAI222S U1809 ( .A1(n1354), .A2(n1430), .B1(n1361), .B2(n1353), .C1(n1404), 
        .C2(n1359), .O(n682) );
  OAI222S U1810 ( .A1(n1354), .A2(n1433), .B1(n1362), .B2(n1353), .C1(n1406), 
        .C2(n1359), .O(n681) );
  OAI222S U1811 ( .A1(n1354), .A2(n1436), .B1(n1363), .B2(n1353), .C1(n1408), 
        .C2(n1359), .O(n680) );
  OAI222S U1812 ( .A1(n1354), .A2(n1439), .B1(n1364), .B2(n1353), .C1(n1410), 
        .C2(n1359), .O(n679) );
  OAI222S U1813 ( .A1(n1354), .A2(n1444), .B1(n1366), .B2(n1353), .C1(n1414), 
        .C2(n1359), .O(n678) );
  ND2S U1814 ( .I1(n1355), .I2(n1416), .O(n1368) );
  ND2S U1815 ( .I1(n1356), .I2(n1418), .O(n1357) );
  MOAI1S U1816 ( .A1(n1398), .A2(n1380), .B1(n1473), .B2(n1357), .O(n1358) );
  NR2 U1817 ( .I1(n1454), .I2(n1358), .O(n1367) );
  OR2S U1818 ( .I1(n1359), .I2(n1424), .O(n1365) );
  OAI222S U1819 ( .A1(n1368), .A2(n1427), .B1(n1371), .B2(n1367), .C1(n1360), 
        .C2(n1365), .O(n677) );
  OAI222S U1820 ( .A1(n1368), .A2(n1430), .B1(n1372), .B2(n1367), .C1(n1361), 
        .C2(n1365), .O(n676) );
  OAI222S U1821 ( .A1(n1368), .A2(n1433), .B1(n1373), .B2(n1367), .C1(n1362), 
        .C2(n1365), .O(n675) );
  OAI222S U1822 ( .A1(n1368), .A2(n1436), .B1(n1374), .B2(n1367), .C1(n1363), 
        .C2(n1365), .O(n674) );
  OAI222S U1823 ( .A1(n1368), .A2(n1439), .B1(n1375), .B2(n1367), .C1(n1364), 
        .C2(n1365), .O(n673) );
  OAI222S U1824 ( .A1(n1368), .A2(n1444), .B1(n1377), .B2(n1367), .C1(n1366), 
        .C2(n1365), .O(n672) );
  ND2S U1825 ( .I1(bottom_compare_f[0]), .I2(n1370), .O(n1379) );
  OAI22S U1826 ( .A1(bottom_compare_f[0]), .A2(n1398), .B1(n1456), .B2(n1370), 
        .O(n1369) );
  NR2 U1827 ( .I1(n1454), .I2(n1369), .O(n1378) );
  ND2S U1828 ( .I1(n1449), .I2(n1370), .O(n1376) );
  OAI222S U1829 ( .A1(n1379), .A2(n1427), .B1(n1382), .B2(n1378), .C1(n1371), 
        .C2(n1376), .O(n671) );
  OAI222S U1830 ( .A1(n1379), .A2(n1430), .B1(n1384), .B2(n1378), .C1(n1372), 
        .C2(n1376), .O(n670) );
  OAI222S U1831 ( .A1(n1379), .A2(n1433), .B1(n1386), .B2(n1378), .C1(n1373), 
        .C2(n1376), .O(n669) );
  OAI222S U1832 ( .A1(n1379), .A2(n1436), .B1(n1388), .B2(n1378), .C1(n1374), 
        .C2(n1376), .O(n668) );
  OAI222S U1833 ( .A1(n1379), .A2(n1439), .B1(n1390), .B2(n1378), .C1(n1375), 
        .C2(n1376), .O(n667) );
  OAI222S U1834 ( .A1(n1379), .A2(n1444), .B1(n1394), .B2(n1378), .C1(n1377), 
        .C2(n1376), .O(n666) );
  OA12S U1835 ( .B1(n1380), .B2(bottom_compare_f[0]), .A1(n1473), .O(n1393) );
  OR2S U1836 ( .I1(n1447), .I2(n1393), .O(n1395) );
  NR2 U1837 ( .I1(n1454), .I2(n1393), .O(n1391) );
  OAI222S U1838 ( .A1(n1395), .A2(n1382), .B1(n1427), .B2(n1393), .C1(n1381), 
        .C2(n1391), .O(n665) );
  OAI222S U1839 ( .A1(n1395), .A2(n1384), .B1(n1430), .B2(n1393), .C1(n1383), 
        .C2(n1391), .O(n664) );
  OAI222S U1840 ( .A1(n1395), .A2(n1386), .B1(n1433), .B2(n1393), .C1(n1385), 
        .C2(n1391), .O(n663) );
  OAI222S U1841 ( .A1(n1395), .A2(n1388), .B1(n1436), .B2(n1393), .C1(n1387), 
        .C2(n1391), .O(n662) );
  OAI222S U1842 ( .A1(n1395), .A2(n1390), .B1(n1439), .B2(n1393), .C1(n1389), 
        .C2(n1391), .O(n661) );
  OAI222S U1843 ( .A1(n1395), .A2(n1394), .B1(n1444), .B2(n1393), .C1(n1392), 
        .C2(n1391), .O(n660) );
  ND2S U1844 ( .I1(n1396), .I2(n1400), .O(n1415) );
  OAI22S U1845 ( .A1(n1456), .A2(n1400), .B1(n1398), .B2(n1397), .O(n1399) );
  NR2 U1846 ( .I1(n1454), .I2(n1399), .O(n1413) );
  ND2S U1847 ( .I1(n1449), .I2(n1400), .O(n1411) );
  OAI222S U1848 ( .A1(n1415), .A2(n1427), .B1(n1402), .B2(n1413), .C1(n1401), 
        .C2(n1411), .O(n659) );
  OAI222S U1849 ( .A1(n1415), .A2(n1430), .B1(n1404), .B2(n1413), .C1(n1403), 
        .C2(n1411), .O(n658) );
  OAI222S U1850 ( .A1(n1415), .A2(n1433), .B1(n1406), .B2(n1413), .C1(n1405), 
        .C2(n1411), .O(n657) );
  OAI222S U1851 ( .A1(n1415), .A2(n1436), .B1(n1408), .B2(n1413), .C1(n1407), 
        .C2(n1411), .O(n656) );
  OAI222S U1852 ( .A1(n1415), .A2(n1439), .B1(n1410), .B2(n1413), .C1(n1409), 
        .C2(n1411), .O(n655) );
  OAI222S U1853 ( .A1(n1415), .A2(n1444), .B1(n1414), .B2(n1413), .C1(n1412), 
        .C2(n1411), .O(n654) );
  ND2S U1854 ( .I1(n1417), .I2(n1416), .O(n1445) );
  ND2S U1855 ( .I1(n1419), .I2(n1418), .O(n1422) );
  OR2S U1856 ( .I1(n1454), .I2(n1420), .O(n1421) );
  AOI13HS U1857 ( .B1(n1473), .B2(N964), .B3(n1422), .A1(n1421), .O(n1442) );
  AO12S U1858 ( .B1(N964), .B2(n1424), .A1(n1423), .O(n1440) );
  OAI222S U1859 ( .A1(n1445), .A2(n1427), .B1(n1426), .B2(n1442), .C1(n1425), 
        .C2(n1440), .O(n653) );
  OAI222S U1860 ( .A1(n1445), .A2(n1430), .B1(n1429), .B2(n1442), .C1(n1428), 
        .C2(n1440), .O(n652) );
  OAI222S U1861 ( .A1(n1445), .A2(n1433), .B1(n1432), .B2(n1442), .C1(n1431), 
        .C2(n1440), .O(n651) );
  OAI222S U1862 ( .A1(n1445), .A2(n1436), .B1(n1435), .B2(n1442), .C1(n1434), 
        .C2(n1440), .O(n650) );
  OAI222S U1863 ( .A1(n1445), .A2(n1439), .B1(n1438), .B2(n1442), .C1(n1437), 
        .C2(n1440), .O(n649) );
  OAI222S U1864 ( .A1(n1445), .A2(n1444), .B1(n1443), .B2(n1442), .C1(n1441), 
        .C2(n1440), .O(n648) );
  NR2 U1865 ( .I1(n1446), .I2(n1454), .O(n1450) );
  OAI22S U1866 ( .A1(n1448), .A2(n1450), .B1(score_f[0]), .B2(n1447), .O(n647)
         );
  ND2S U1867 ( .I1(n1449), .I2(score_f[0]), .O(n1452) );
  OAI12HS U1868 ( .B1(score_f[0]), .B2(n1456), .A1(n1450), .O(n1451) );
  MOAI1S U1869 ( .A1(score_f[1]), .A2(n1452), .B1(score_f[1]), .B2(n1451), .O(
        n646) );
  ND3S U1870 ( .I1(n1453), .I2(score_f[1]), .I3(score_f[0]), .O(n1457) );
  OAI22S U1871 ( .A1(n1473), .A2(n1454), .B1(n1457), .B2(n1454), .O(n1459) );
  ND2S U1872 ( .I1(n1473), .I2(n1455), .O(n1458) );
  OAI22S U1873 ( .A1(n1459), .A2(n1455), .B1(n1458), .B2(n1457), .O(n645) );
  OR3S U1874 ( .I1(n1457), .I2(n1456), .I3(n1455), .O(n1461) );
  ND2S U1875 ( .I1(n1459), .I2(n1458), .O(n1460) );
  MOAI1S U1876 ( .A1(score_f[3]), .A2(n1461), .B1(score_f[3]), .B2(n1460), .O(
        n644) );
  MOAI1S U1877 ( .A1(n764), .A2(n1462), .B1(n764), .B2(position[2]), .O(n643)
         );
  MOAI1S U1878 ( .A1(n764), .A2(n1463), .B1(n764), .B2(position[1]), .O(n642)
         );
  MOAI1S U1879 ( .A1(n764), .A2(n1464), .B1(n764), .B2(position[0]), .O(n641)
         );
endmodule

