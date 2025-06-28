import 'dart:typed_data';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import 'package:kasir_klmpk6/enum/printEnum.dart';
import 'package:kasir_klmpk6/model/product.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;


///Test printing
class TestPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future<void> sample({
    required List<Map<String, dynamic>> items,
    required String paymentMethod,
    required int total,
  }) async {
    // image logo (optional)
    // String filename = 'yourlogo.png';
    // ByteData bytesData = await rootBundle.load("assets/images/yourlogo.png");
    // String dir = (await getApplicationDocumentsDirectory()).path;
    // File file = await File('$dir/$filename').writeAsBytes(bytesData.buffer
    //     .asUint8List(bytesData.offsetInBytes, bytesData.lengthInBytes));

    bluetooth.isConnected.then((isConnected) {
      if (isConnected == true) {
        bluetooth.printNewLine();
        bluetooth.printCustom("STRUK TRANSAKSI", Size.boldLarge.val, Align.center.val);
      
        bluetooth.printNewLine();

        bluetooth.printCustom("Daftar Barang:", Size.bold.val, Align.left.val);

        for (var item in items) {
          final product = item['product'] as Product;
          final qty = item['qty'] as int;
          final hargaTotal = product.harga * qty;

          // Contoh format: "NamaBarang xQty ..... Rp Harga"
          bluetooth.printLeftRight(
            "${product.namaBarang} x$qty",
            "Rp $hargaTotal",
            Size.medium.val,
          );
        }

        bluetooth.printNewLine();
        bluetooth.printLeftRight("Metode Pembayaran:", paymentMethod, Size.bold.val);
        bluetooth.printLeftRight("TOTAL:", "Rp $total", Size.boldLarge.val);

        bluetooth.printNewLine();
        bluetooth.printCustom("Terima Kasih!", Size.bold.val, Align.center.val);
        bluetooth.printNewLine();
      } else {
        print("Printer belum terhubung!");
      }
    });
  }
}

//   sample(String pathImage) async {
//     //SIZE
//     // 0- normal size text
//     // 1- only bold text
//     // 2- bold with medium text
//     // 3- bold with large text
//     //ALIGN
//     // 0- ESC_ALIGN_LEFT
//     // 1- ESC_ALIGN_CENTER
//     // 2- ESC_ALIGN_RIGHT
//
// //     var response = await http.get("IMAGE_URL");
// //     Uint8List bytes = response.bodyBytes;
//     bluetooth.isConnected.then((isConnected) {
//       if (isConnected == true) {
//         bluetooth.printNewLine();
//         bluetooth.printCustom("HEADER", 3, 1);
//         bluetooth.printNewLine();
//         bluetooth.printImage(pathImage); //path of your image/logo
//         bluetooth.printNewLine();
// //      bluetooth.printImageBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
//         bluetooth.printLeftRight("LEFT", "RIGHT", 0);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 1);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 1, format: "%-15s %15s %n");
//         bluetooth.printNewLine();
//         bluetooth.printLeftRight("LEFT", "RIGHT", 2);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 3);
//         bluetooth.printLeftRight("LEFT", "RIGHT", 4);
//         bluetooth.printNewLine();
//         bluetooth.print3Column("Col1", "Col2", "Col3", 1);
//         bluetooth.print3Column("Col1", "Col2", "Col3", 1,
//             format: "%-10s %10s %10s %n");
//         bluetooth.printNewLine();
//         bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1);
//         bluetooth.print4Column("Col1", "Col2", "Col3", "Col4", 1,
//             format: "%-8s %7s %7s %7s %n");
//         bluetooth.printNewLine();
//         String testString = " čĆžŽšŠ-H-ščđ";
//         bluetooth.printCustom(testString, 1, 1, charset: "windows-1250");
//         bluetooth.printLeftRight("Številka:", "18000001", 1,
//             charset: "windows-1250");
//         bluetooth.printCustom("Body left", 1, 0);
//         bluetooth.printCustom("Body right", 0, 2);
//         bluetooth.printNewLine();
//         bluetooth.printCustom("Thank You", 2, 1);
//         bluetooth.printNewLine();
//         bluetooth.printQRcode("Insert Your Own Text to Generate", 200, 200, 1);
//         bluetooth.printNewLine();
//         bluetooth.printNewLine();
//         bluetooth.paperCut();
//       }
//     });
//   }
