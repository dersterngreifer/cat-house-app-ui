class Kucing {
  String nama;
  String jenis;
  String warnaBulu;
  DateTime tanggalLahir;
  double beratBadan;
  String jenisKelamin;
  String statusKesehatan;
  String vaksinasi;
  String makanan;
  String nomorMikrochip;
  String pemilik;
  String catatanKhusus;
  int harga;
  String foto;

  Kucing({
    required this.nama,
    required this.jenis,
    required this.warnaBulu,
    required this.tanggalLahir,
    required this.beratBadan,
    required this.jenisKelamin,
    required this.statusKesehatan,
    required this.vaksinasi,
    required this.makanan,
    required this.nomorMikrochip,
    required this.pemilik,
    required this.catatanKhusus,
    required this.harga,
    required this.foto,
  });

  static List<Kucing> getDataKucing() {
    List<Kucing> data = [
      Kucing(
        nama: "Chiko Bloon",
        jenis: "Persia",
        warnaBulu: "Coklat",
        tanggalLahir: DateTime(2020, 5, 15),
        beratBadan: 4.5,
        jenisKelamin: "Betina",
        statusKesehatan: "Sehat",
        vaksinasi: "Rutin",
        makanan: "Royal Canin",
        nomorMikrochip: "123456789",
        pemilik: "Budi",
        catatanKhusus:
            "Chiko Bloon adalah kucing Persia yang lincah dan aktif. Dia senang bermain dengan mainan dan selalu ceria. Bulunya berwarna coklat lembut, membuatnya terlihat menggemaskan.",
        harga: 5000000,
        foto: "https://i.imgur.com/F1ypNFQ.png",
      ),
      Kucing(
        nama: "Oreo",
        jenis: "Maine Coon",
        warnaBulu: "Hitam Putih",
        tanggalLahir: DateTime(2019, 8, 20),
        beratBadan: 7.2,
        jenisKelamin: "Jantan",
        statusKesehatan: "Cacat Kaki Belakang",
        vaksinasi: "Tertunda",
        makanan: "Hill's Science Diet",
        nomorMikrochip: "987654321",
        pemilik: "Citra",
        catatanKhusus:
            "Oreo adalah kucing Maine Coon yang memiliki bulu hitam putih yang mencolok. Meskipun memiliki cacat pada kaki belakangnya, Oreo tetap menjadi kucing yang ceria dan penuh kasih.",
        harga: 7000000,
        foto: "https://i.imgur.com/GsU1Bot.png",
      ),
      Kucing(
        nama: "Whiskers",
        jenis: "Scottish Fold",
        warnaBulu: "Abu-abu",
        tanggalLahir: DateTime(2021, 3, 10),
        beratBadan: 3.8,
        jenisKelamin: "Betina",
        statusKesehatan: "Sehat",
        vaksinasi: "Rutin",
        makanan: "Iams",
        nomorMikrochip: "345678912",
        pemilik: "Diana",
        catatanKhusus:
            "Whiskers adalah kucing Scottish Fold yang menggemaskan dengan bulu abu-abu yang lembut. Dia senang bermain dengan bola wol dan selalu suka berjemur di bawah matahari.",
        harga: 6000000,
        foto: "https://i.imgur.com/xu3wZdN.png",
      ),
      Kucing(
        nama: "Simba",
        jenis: "Bengal",
        warnaBulu: "Bintik-bintik",
        tanggalLahir: DateTime(2020, 9, 5),
        beratBadan: 5.0,
        jenisKelamin: "Jantan",
        statusKesehatan: "Sehat",
        vaksinasi: "Rutin",
        makanan: "Purina Pro Plan",
        nomorMikrochip: "678912345",
        pemilik: "Eko",
        catatanKhusus:
            "Simba adalah kucing Bengal yang energetik dan suka bermain dengan mainan kecil. Bulunya berwarna bintik-bintik, mirip dengan seekor harimau kecil yang menggemaskan.",
        harga: 7500000,
        foto: "https://i.imgur.com/fvqC8Du.jpg",
      ),
      Kucing(
        nama: "Luna",
        jenis: "Siamese",
        warnaBulu: "Putih",
        tanggalLahir: DateTime(2019, 12, 8),
        beratBadan: 4.2,
        jenisKelamin: "Betina",
        statusKesehatan: "Sehat",
        vaksinasi: "Rutin",
        makanan: "Fancy Feast",
        nomorMikrochip: "891234567",
        pemilik: "Rita",
        catatanKhusus:
            "Luna adalah kucing Siamese yang anggun dengan bulu putih yang indah. Dia suka berjemur di bawah matahari dan selalu menjadi pusat perhatian dengan tatapan mata birunya yang memesona.",
        harga: 5500000,
        foto: "https://i.imgur.com/96hBKVL.jpg",
      ),
    ];

    return data;
  }
}
