-- phpMyAdmin SQL Dump
-- version 5.2.3
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : lun. 18 mai 2026 à 21:34
-- Version du serveur : 10.6.23-MariaDB-0ubuntu0.22.04.1
-- Version de PHP : 8.4.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `evenement`
--

-- --------------------------------------------------------

--
-- Structure de la table `artiste`
--

CREATE TABLE `artiste` (
  `idArtiste` int(11) NOT NULL,
  `nom` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `genre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `photo` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `artiste`
--

INSERT INTO `artiste` (`idArtiste`, `nom`, `genre`, `photo`) VALUES
(1, 'David Guetta', '', 'https://electro-news.eu/wp-content/uploads/2021/01/david-guetta-scaled.jpg'),
(2, 'Taylor Swift', '', 'https://resize-elle.ladmedia.fr/r/625,,forcex/crop/625,804,center-middle,forcex,ffffff/img/var/plain_site/storage/images/personnalites/taylor-swift/42391722-2-fre-FR/Taylor-Swift.jpg'),
(3, 'Symphony of Unity', '', 'https://prismic-assets-cdn.tomorrowland.com/Zg5YdTskWekewC1z_1690648109136_78786f9b-70c5-46dd-9f5b-a9d94c42a40f.jpg_5504_16994556994422367398.jpg'),
(4, 'Marlon Hoffstadt', '', 'https://i.discogs.com/8LMi4gSq_TX6Po3HFN3Hq1o6ZFNtshe-x9uimUEh0ys/rs:fit/g:sm/q:90/h:600/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTI2MjMw/NjEtMTU5OTAzNjQ3/NS05NjI2LmpwZWc.jpeg'),
(5, 'Martin Garrix', '', 'https://d21buns5ku92am.cloudfront.net/68681/images/388052-JBL%2Bx_shootHighRes_v3-58e07d-large-1618928217.png'),
(6, 'Kevin de Vries', '', 'https://www.guettapen.com/wp-content/uploads/2022/08/Kevin-De-Vries-web.jpg'),
(7, 'Tiësto', '', 'https://media.lasvegasmagazine.com/media/img/photos/2022/05/06/Tiesto_CDV_LD2_t1024.jpg?b3f067808e872500b33dd7ef4ee517933144b05a'),
(8, 'Timmy Trumpet', '', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCEll0L6mVJsZwkVVdxaFM56yiq10GT_bWfg&s'),
(9, 'Tita Lau', '', 'https://d3vhc53cl8e8km.cloudfront.net/hello-staging/wp-content/uploads/2023/04/13230929/5laM2bqLzm5jcPqmvt3xcGQUpaGUZXwMoYJ8lXEb-972x597.jpeg'),
(10, 'Wade', '', 'https://geo-media.beatport.com/image_size/590x404/62774c85-8d5b-46d1-b243-329abde322ea.jpg'),
(11, 'Kygo', '', 'https://dynamicmedia.livenationinternational.com/a/w/i/3a3cb268-09d3-42e7-bf75-bee58df05193.jpg'),
(12, 'Sofi Tukker', '', 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEgQlqtl-NVjroJuN05mU-agFpSGLDSo7gnQHee1Lo8VaYJz49mfFqjFDzudZpfkiN_Xa6gRQNXe6-V-b4OskLff8ZmVaQxMfLUMSqbKEyQIZvdco-tZMaS_FH6l4AlbxPpVS7N1cRLz5OM/s1600/SOFI.jpg'),
(13, 'DJ Snake', '', 'https://i.scdn.co/image/ab6761610000e5ebca97cf089968b569e29d795c'),
(14, 'Trinix', '', 'https://www.artistikrezo.com/wp-content/uploads/2022/12/Trinixmusic-830x1024.jpg'),
(15, 'Saverio', '', 'https://res.cloudinary.com/shotgun/image/upload/v1709904195/production/artworks/artists/saveriodj.jpg'),
(16, 'Mosimann', '', 'https://cloudfront-eu-central-1.images.arcpublishing.com/leparisien/YFFKBA75KJG3LDYBF3S3XHNG6Y.jpg'),
(17, 'Petit Biscuit', '', 'https://www.rodmusic.fr/wp-content/uploads/2023/07/PetitBiscuit_YouDontIgnore.jpg'),
(18, 'Ofenbach', '', 'https://res.cloudinary.com/shotgun/image/upload/v1705684067/production/artworks/artists/weareofenbach.jpg'),
(19, 'Meduza', '', 'https://photos.bandsintown.com/thumb/11253357.jpeg'),
(20, 'Kungs', '', 'https://image.ausha.co/b7W1RD6nraiWmu2f9F0OhL1ytLsF8H42ZU9qbyFD_1400x1400.jpeg?t=1687238667'),
(21, 'Tchami & Malaa', '', 'https://www.dancemusicnw.com/wp-content/uploads/2018/04/no-redemption.jpg'),
(22, 'Martin Solveig', '', 'https://yt3.googleusercontent.com/ytc/AIdro_nr2qRuQOWWSIZTtRDsRZiK3SaqEN6QHIw8HDHo7wXk-ms=s900-c-k-c0x00ffffff-no-rj'),
(23, 'Diplo', '', 'https://www.solidays.org/wp-content/uploads/2023/11/diplo_minia-1140x570.jpg'),
(24, 'R3HAB', '', 'https://img.nrj.fr/hP0GWAWZxBpWG1iPUsxJVgYiVqA=/800x450/smart/medias%2F2025%2F09%2Fpkwzflx7g9orsbbncstbz3v8t0jtgqpwqi9imbojgvk_68cc10940ea18.jpg'),
(25, 'W&W', 'D', 'https://images.xceed.me/artists/covers/w-w-artist-xceed-cover-3ae9.jpg'),
(26, 'Tate McRae', '', 'https://ca.billboard.com/media-library/tate-mcrae-at-the-2023-billboard-music-awards-at-the-moxy-hotel-in-los-angeles-california-the-show-airs-on-november-19-2023-o.jpg?id=50515696&width=1200&height=800&quality=90&coordinates=0%2C0%2C0%2C0'),
(27, 'Charlieonnafriday', '', 'https://dynamicmedia.livenationinternational.com/a/d/g/52886b00-626f-4999-9569-dd778d754239.jpg'),
(28, 'Paramore', '', 'https://www.rocktotal.com/wp-content/uploads/2021/11/paramore.jpg'),
(29, 'Mike Dean', '', 'https://www.rollingstone.com/wp-content/uploads/2020/04/mike-dean.jpg'),
(30, 'Alan Walker', '', 'https://tinderbox.dk/wp-content/uploads/sites/2/2024/02/Alan-Walker.jpg'),
(31, 'Au/Ra', '', 'https://d2ljoqkkoec4f6.cloudfront.net/wp-content/uploads/2022/01/17164619/a1.jpg'),
(32, 'Goodboys', '', 'https://headlinermagazine.net/assets/img/assets/img/2022/Goodboys_interview_1_1.jpg'),
(33, 'DJ Bens', '', 'https://www.warehouse-nantes.fr/media/cache/square_1000/images/artist_image/68d3f3f2a0172000536179.webp'),
(34, 'Vladimir Cauchemar', '', 'https://media.sudouest.fr/11731207/1200x600/vlad2.jpg'),
(35, 'Le Pedre', '', 'https://img.nrj.fr/BlBbv7bUJLmNBTVY9IFh4JTH7FM=/800x450/smart/medias%2F2021%2F04%2Ffloydrenton-9_607d60988c073.jpg'),
(36, 'Raw', 'H', 'https://scontent-cdg4-1.cdninstagram.com/v/t39.30808-6/469076953_18021226568632409_8881683693974761969_n.jpg?stp=dst-jpg_e35_s1080x1080_tt6&efg=eyJ2ZW5jb2RlX3RhZyI6ImltYWdlX3VybGdlbi4xNDQweDk2MC5zZHIuZjMwODA4LmRlZmF1bHRfaW1hZ2UifQ&_nc_ht=scontent-cdg4-1.cdninstagram.com&_nc_cat=105&_nc_oc=Q6cZ2AFbhojFbtDeyrP9Tt_KMJt57YZypzTpAx1xH8PBEItZV5eK20FTsee1kE-aKAnqNCfqsi2Nmcj14nv_Ib2AlM8a&_nc_ohc=DVEDDqIE2CsQ7kNvgGepTC8&_nc_gid=da63441f0cc04490a767d794f7da5812&edm=APoiHPcAAAAA&ccb=7-5&ig_cache_key=MzQ2ODYzMDgyMTc3NzI0MTkxNw%3D%3D.3-ccb7-5&oh=00_AYHtbIxPB_fsLiFFDuehBGjTi82SoBqIFsPxFwLFzk_SjQ&oe=67D3A925&_nc_sid=22de04'),
(37, 'Shad', '', 'https://maville.com/photosmvi/2023/08/28/P33152581D5912152G.jpg'),
(38, 'Snight B', '', 'https://static.actu.fr/uploads/2020/09/dj-snight-b-960x640.jpg'),
(39, 'Angèle Brol', '', 'https://images.rtl.fr/~c/1200v800/rtl/www/1218186-festival-de-cannes-2019-la-chanteuse-belge-angele-sur-le-tapis-rouge.jpg'),
(40, 'Adèle Castillon', '', 'https://www.aficia.info/wp-content/uploads/2023/06/banniere-aficia-23.png'),
(41, 'Ava Max', '', 'https://img.nrj.fr/YxkaFD8L6YgWU7LRlZhO7IlGf2g=/medias%2F2022%2F10%2F634016a586507_634016ad7916f.jpg'),
(42, 'Joel Corry', '', 'https://ibiza-spotlight1.b-cdn.net/sites/default/files/styles/auto_1500_width/public/article-images/139645/slideshow-1690975568.jpg'),
(43, 'KSHMR', '', 'https://geo-media.beatport.com/image_size/590x404/a96299a8-5406-4d04-a66c-6f5cb2c8a229.jpg'),
(44, 'Alok', '', 'https://www.exitfest.org/wp-content/uploads/2024/04/alok.jpg'),
(45, 'Steve Aoki', '', 'https://d3vhc53cl8e8km.cloudfront.net/hello-staging/wp-content/uploads/2014/05/21213257/cb672a62-3015-11ef-954e-0ecc81f4ee58-972x597.jpg'),
(46, 'Bekar', '', 'https://i.scdn.co/image/ab6761610000e5eb4e1b2b2e2efe9fe375730ac8'),
(47, 'Maroon 5', '', 'https://img.nrj.fr/5K1XR16ymb3Vg5qrR4x7WbtXL0o=/medias%2F2020%2F10%2Fm5-bs-press-1a_5f92e8168c535.jpg'),
(48, 'Damso', '', 'https://i.f1g.fr/media/cms/orig/2024/02/15/46cf8efef4ee45f70c381bd1f1e31d7d5a6d7dd65a2283c049f17592a32c95d7.jpg'),
(49, 'Niall Horan', '', 'https://www.rollingstone.com/wp-content/uploads/2023/06/Niall-Horan-Album.jpg?w=1581&h=1054&crop=1'),
(50, 'The driver Era', '', 'https://i.discogs.com/SrI9EPzNue_31ZtAj_fLf1ypGex8l8UpqZ4s9z6kleQ/rs:fit/g:sm/q:90/h:400/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9BLTEwMTYx/MzE2LTE2NjMzNDUz/MzQtOTY4Ny5qcGVn.jpeg'),
(51, 'Lil Nas X', '', 'https://www.booska-p.com/wp-content/uploads/2023/12/Lil-Nas-X-Visu-News-1024x750.jpg'),
(52, 'Rosalia', '', 'https://imageio.forbes.com/specials-images/imageserve/639ba21c2c89cf5733659135/Rosalia-Concert-In-Madrid/960x0.jpg?format=jpg&width=960'),
(53, 'The Weeknd', '', 'https://www.radiofrance.fr/s3/cruiser-production/2021/05/e1e9f515-d792-41cd-8872-189e62905985/870x489_gettyimages-1231050791_1.jpg'),
(54, 'Kaytranada', '', 'https://www.billboard.com/wp-content/uploads/2023/06/cover-kaytranada-billboard-2023-bb8-joelle-grace-taylor-3-1240.jpg?w=683'),
(55, 'M.Pokora', '', 'https://www.parismatch.com/lmnr/var/pm/public/media/image/M.-Pokora.jpg?VersionId=BJvcfj5O639ixWHhpV7OL11_Ola7Vj7m'),
(56, 'Tal', '', 'https://img.nrj.fr/ezgxAJ31jpch-69XcDel3n1Saes=/https%3A%2F%2Fmedia.nrj.fr%2F1900x1200%2F2016%2F09%2Ftal-jpg-3979385.jpg'),
(57, 'Magic System', '', 'https://i.scdn.co/image/504e83f4449769bb0ba38b8b149e6659f97bb743'),
(58, 'Max & Mango', '', 'https://yt3.googleusercontent.com/ytc/AIdro_lPaFsk1qeWWhi0U87s0JKZYhvesJ7inMzxewEA=s900-c-k-c0x00ffffff-no-rj'),
(59, 'Syndy', '', 'https://img.ohmymag.com/s3/fromm/1280/people/default_2020-03-02_d1b670e9-889d-41d7-9328-a55e60d46aa8.jpeg'),
(60, 'Black M', '', 'https://www.booska-p.com/wp-content/uploads/2023/11/Black-M-Racisme-Visu-News.jpg'),
(61, 'Aya Nakamura', '', 'https://www.parismatch.com/lmnr/var/pm/public/media/image/2024/04/10/20/pm-aya-nakamura-2.jpg?VersionId=6oMbQ62kc019Zq.FRsXSEhVJSB3DE51W'),
(62, 'Dua Lipa', '', 'https://resize.elle.fr/original/var/plain_site/storage/images/loisirs/musique/news/dua-lipa-choses-que-vous-ne-saviez-pas-sur-la-chanteuse-4100691/98327226-1-fre-FR/Dua-Lipa-5-choses-que-vous-ne-saviez-pas-sur-la-chanteuse.jpg'),
(63, 'Sexion d\'assaut', '', 'https://sf1.closermag.fr/wp-content/uploads/closermag/2023/05/la-sexion-assaut-reforme-pour-une-grande-tournee-2022.jpeg'),
(64, 'Robin Schulz', '', 'https://www.pop-himmel.de/wp-content/uploads/2023/07/Robin-Schulz-Main-Press-Image-2023-1-Credit-Philipp-Gladsome-800x600.jpg'),
(65, 'Zazie', '', 'https://www.parismatch.com/lmnr/var/pm/public/media/image/2023/08/22/11/sipa_01119040_000008.jpg?VersionId=kVAoFT_iYx8lWgLV93EmhXT71TFW48fm'),
(66, 'Skip the Use', '', 'https://lvdneng.rosselcdn.net/sites/default/files/dpistyles_v2/ena_16_9_extra_big/2019/11/20/node_668542/43450469/public/2019/11/20/B9721658051Z.1_20191120215559_000%2BG9TEV17HJ.4-0.jpg?itok=F7p0ovkZ1574283411'),
(67, '-M-', '', 'https://img-3.journaldesfemmes.fr/Pdh6-sdbTRVjDttFKMGiziSOshw=/1500x/smart/247afdf8ba3447f0b4be00f03b49a0bc/ccmcms-jdf/39933484.jpg'),
(68, 'Roszalie', '', 'https://antipode-rennes.fr/sites/default/files/antipode/styles/facebook_partage/public/ged/atoem_-_titouan_masse-06295.jpeg?itok=x6ARQ97e'),
(69, 'Toukan Toukän', '', 'https://i0.wp.com/lesoreillescurieuses.com/wp-content/uploads/2022/11/4156675E-C47C-4183-BAF8-50CCA4550D63.jpeg?fit=2560%2C2560&ssl=1'),
(70, 'Morten', '', 'https://images.sk-static.com/images/media/profile_images/artists/8574784/huge_avatar'),
(71, 'Gryffin', '', 'https://resources.tidal.com/images/c0326d6a/6e3c/48a5/acec/a5f21359e83b/750x750.jpg'),
(72, 'Dimitri Vegas', '', 'https://d3vhc53cl8e8km.cloudfront.net/hello-staging/wp-content/uploads/2024/06/21184250/feb34ef4-2ffd-11ef-b991-0ee6b8365494-1-972x597.jpg'),
(73, 'Anyma', '', 'https://www.popnmusic.fr/wp-content/uploads/2024/03/Anyma-revele-la-date-de-sortie-et-la-tracklist-de.png'),
(74, 'Dimitri Vegas & Like Mike', '', 'https://cdn-s-www.ledauphine.com/images/7DD71840-B4A9-4E60-9B4E-94445E269729/NW_raw/les-deux-freres-dimitri-vegas-et-like-mike-n-1-mondial-du-dernier-classement-dj-mag-seront-a-pharaonic-le-21-mars-a-chambery-photo-dr-1575967020.jpg'),
(75, 'Monocule', '', 'https://weraveyou.com/wp-content/uploads/2020/01/Nicky-Romero-Press-by-Kevin-Anthony-Canales.jpg'),
(76, 'Kölsch', '', 'https://media.watchthedj.com/djs/kolsch.jpg'),
(77, 'Push', '', 'https://img.gva.be/w0xAXmDci7itKYACr-vPuzwnx4A=/960x640/smart/https%3A%2F%2Fstatic.gva.be%2FAssets%2FImages_Upload%2F2019%2F02%2F21%2F4046402c-2dea-11e9-9651-f26683fc8ddf_web_scale_0.1612115_0.1612115__.jpg'),
(78, 'John Newman', '', 'https://i.scdn.co/image/ab6761610000e5eb4eaf903c2b9df9217dafeba8'),
(79, 'Hardwell', '', 'https://static-cdn.toi-media.com/fr/uploads/2022/04/%D7%93%D7%99-%D7%92%D7%99-%D7%94%D7%90%D7%A8%D7%93%D7%95%D7%95%D7%9C-%D7%A6%D7%99%D7%9C%D7%95%D7%9D-%D7%99%D7%97%D7%A6-%D7%94%D7%90%D7%A8%D7%93%D7%95%D7%95%D7%9C.jpeg'),
(80, 'Barbara Butch', '', 'https://www.contemporainedenimes.com/cdn23_files/uploads/2024/02/Barbara-Butch.jpeg'),
(81, 'Feder', '', 'https://img.nrj.fr/cv60KxxuiS5fKIpX5ATS7fTQEgg=/medias%2F2022%2F10%2F633fe080bf18d_633fe08336040.jpg'),
(82, 'Klangkarussell', '', 'https://imgproxy.ra.co/_/quality:66/aHR0cHM6Ly9zdGF0aWMucmEuY28vaW1hZ2VzL3Byb2ZpbGVzL3NxdWFyZS9rbGFuZ2thcnVzc2VsbC5qcGc_ZGF0ZVVwZGF0ZWQ9MTU4NzU0OTc3NDAwMA=='),
(83, 'James Hype', '', 'https://static.billets.ca/artist/j8k/h2/james-hype-1200x750.jpg'),
(84, 'Imagine Dragons', '', 'https://lh3.googleusercontent.com/TAadzeojHFGU1EJ5jnOWDn6K8Cf8O2x0F04PVxnZwUEhcaYN0pA0dic49VU7OKGs7oovBTylWx70xhY=w2880-h1200-p-l90-rj'),
(85, 'Declan McKenna', '', 'https://cdn.prod.website-files.com/607e857d7feb56d9de8c60ab/657763ffcd9067257d7f9b79_Declan-McKenna-4.webp'),
(86, 'Katy Perry', '', 'https://ichef.bbci.co.uk/ace/standard/2560/cpsprodpb/5e57/live/88fd3480-49ad-11ef-8957-57bc56098a6f.jpg'),
(87, 'Agents of time', 'G', 'https://images.squarespace-cdn.com/content/v1/573c5c8f45bf21715994b612/1710700010061-N08WIC1E5RAIB9TIKWAS/00.jpg?format=1500w'),
(88, 'Armin van Buuren', 'M', 'https://i.scdn.co/image/ca02718b0e5c389073e8dba56417acd36f541523'),
(89, 'John Summit', 'M', 'https://people.com/thmb/iPyaqXaBikLwqPEATlPN-ik7dOU=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(731x267:733x269)/john-summit-071224-3-642881bfffc24f19897799c23cfd71af.jpg'),
(90, 'Swedish House Mafia', 'M', 'https://static.ra.co/images/profiles/square/swedishhousemafia.jpg?dateUpdated=1680120180273'),
(91, 'Griff', 'F', 'https://image.20min.ch/2024/11/19/2c1f1481-4b1e-4e22-a077-cb053f686a5e.jpeg?s=ff30a39a6773decfdbe90535860e40ff'),
(92, 'Hayla', 'F', 'https://i.scdn.co/image/ab6761610000e5eb327e391ef0e0e7b11e2db1c9'),
(93, 'Parson James', 'H', 'https://resources.tidal.com/images/ca1b87d7/1f57/428e/a059/c806b76b5e71/750x750.jpg'),
(94, 'Sandro Cavazza', 'H', 'https://www.c-heads.com/wp-content/uploads/2017/04/01-SandroCavazza_EP.jpg'),
(95, 'Showtek', 'D', 'https://cdn-images.dzcdn.net/images/artist/e17eed9ba4884f57e1f4bc5dc6960584/1900x1900-000000-80-0-0.jpg'),
(96, 'Zak Abel', 'H', 'https://media.glamourmagazine.co.uk/photos/6138c67b2bec5fcec32c3576/master/w_1600%2Cc_limit/Zak_Abel_984_v1_HI_RES.jpg'),
(97, 'Alex Wat', 'H', 'https://images.rtl.fr/~c/365v243/funradio/www/293080-alex-wat.jpg'),
(98, 'Mico C', 'H', 'https://images.rtl.fr/~c/770v513/funradio/www/290300-mico-c.jpg'),
(99, 'Matt', 'H', 'https://images.rtl.fr/~c/770v513/funradio/www/292200-matt.jpg'),
(100, 'Upsilone', 'H', 'https://riani-management.com/wp-content/uploads/2024/06/Upsoline-Artiste-DJ.jpg.webp'),
(101, 'Elfigo', 'H', 'https://i.scdn.co/image/ab6761610000e5eb85b269984905d9c4f2eff886'),
(102, 'Raphael Palacci', 'M', 'https://mesinfos.fr/content/articles/305/A182305/initial-raphel-palacci.jpg'),
(103, 'Gims', 'M', 'https://www.gimstour.com/wp-content/uploads/2023/05/fond_mobile.jpg'),
(104, 'Mayla k', 'F', 'https://www.riffx.fr/wp-content/uploads/2022/07/mayla-k.jpg'),
(105, 'Rovinsky', 'H', 'https://storage.googleapis.com/lkb-prod-public/coverPicture/125803_coverPicture2_18-12-2024_10:20:18.png'),
(106, 'Shyko', 'H', 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTZgIMiAshTSUrgk78b1IM-fEvK5Imx3UZI8Q&s'),
(107, 'Sobaka & Koshka', 'D', 'https://i.scdn.co/image/ab6761610000e5ebbb053adbcad4b0ce3e8c0a59'),
(108, 'Christophe Willem', 'H', 'https://www.savoie.fr/upload/docs/image/jpeg/2024-03/christophe-willem-credit-p-i-e-r-r-e-et-f-l-o-r-e-n-t---press0425_1024_576.jpg.associated/th-980x1000-christophe-willem-credit-p-i-e-r-r-e-et-f-l-o-r-e-n-t---press0425_1024_576.jpg.jpg'),
(109, 'Madeon', 'H', 'https://images.lesindesradios.fr/fit-in/1100x2000/filters:format(webp)/medias/Vsj0LZpM34/image/unnamed1743425416373-format16by9.jpg'),
(110, 'Alessi Rose', 'F', 'https://tgtumixhqhzrjubppeep.supabase.co/storage/v1/object/public/media/imports/73d9ed51-db46-46cc-b9d9-94ceb714f34a/1765755201504-Alessi-Rose-Hype-List-2025-Patrick-Gunning-21.jpg'),
(111, 'Rim\'K', 'H', 'https://www.booska-p.com/wp-content/uploads/2024/02/RimK.jpg'),
(112, 'Kool Shen', 'H', 'https://img.20mn.fr/kg9iqpcsS12DU0QAxWfong/1444x920_rappeur-kool-shen'),
(113, 'Bipolar Shunshine', 'H', 'https://upload.wikimedia.org/wikipedia/commons/9/9c/SP3153.jpg'),
(114, 'Dillon Francis', 'H', 'https://d3vhc53cl8e8km.cloudfront.net/hello-staging/wp-content/uploads/2014/05/21212954/519c8f92-3015-11ef-954e-0ecc81f4ee58-972x597.jpg'),
(115, 'Gashi', 'H', 'https://www.billboard.com/wp-content/uploads/media/gashi-2019-cr-Daniel-Prakopcyk-billboard-1548.jpg'),
(116, 'Space Laces', 'H', 'https://cdn-images.dzcdn.net/images/artist/591d6e7f3f11ffd416726168d9b3e8c2/1900x1900-000000-80-0-0.jpg'),
(117, 'Afrojack', 'H', 'https://d3vhc53cl8e8km.cloudfront.net/hello-staging/wp-content/uploads/2014/05/16060803/f8214edc-f3af-11ed-b991-0ee6b8365494-972x597.jpg'),
(118, 'Gregor Salto', 'H', 'https://cdn-images.dzcdn.net/images/artist/051ea45684f7deb9cd51016279a23e62/1900x1900-000000-80-0-0.jpg'),
(119, 'Sara Landry', 'F', 'https://www.dourfestival.eu/wp-content/uploads/2025/01/venom_portrait_final-1024x1024.jpg'),
(120, 'Miss Monique', 'F', 'https://hiibiza.b-cdn.net/assets/c194ba3d-a4c2-44fd-b58c-e753632d699d--MISSMONIQUE_562f4%20(1).jpg'),
(122, 'AVALAN ROCKSTON', 'D', 'https://i1.sndcdn.com/avatars-G4MuMMWGETUw5fSK-9TeqVA-t1080x1080.jpg'),
(123, 'Matisse & Sadko', 'D', 'https://cdn-images.dzcdn.net/images/artist/89d46db3b69fa65867963136dbeee807/1900x1900-000000-80-0-0.jpg'),
(124, 'Andromedik', 'H', 'https://static.wikia.nocookie.net/monstercat/images/8/89/Andromedik.jpg/revision/latest?cb=20230911103917*'),
(125, 'Alex Wann', 'H', 'https://www.guettapen.com/wp-content/uploads/2023/09/AS-20230719-6-1-e1694554454319.jpg'),
(126, 'Fisher', '', 'https://www.guettapen.com/wp-content/uploads/2023/06/288906844_558545952305089_8859866029052416897_n-2-2.jpg-780x528.webp'),
(127, 'Becky Hill', '', 'https://ziknation.com/wp-content/uploads/2024/10/1730232473_Becky-Hill-repond-aux-informations-conneries-selon-lesquelles-elle-representera.jpg'),
(128, 'Steve Angello', '', 'https://images.rtl.fr/~c/770v513/funradio/www/872927-steve-angellova-travailler-sur-une-serie-liee-a-l-electro.jpg'),
(129, 'Lost Frequencies', '', 'https://d3vhc53cl8e8km.cloudfront.net/artists/1715/158395e6-3015-11ef-b991-0ee6b8365494.jpg'),
(130, 'Bob Sinclar', '', 'https://london.frenchmorning.com/wp-content/uploads/sites/10/2024/09/bob-sinclar-londres.jpg'),
(131, 'Carsen', 'H', 'https://scontent-cdg4-1.xx.fbcdn.net/v/t51.82787-15/658392742_18458207245102109_5838591049345282261_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=13d280&_nc_ohc=nOy5FqpONWkQ7kNvwHl1F6Y&_nc_oc=Ado54kdHAkk1DQyr322STrGx4ETCkjMO-rfrbAtu-zTSqUi7TNDpp7vx0HLoqkanRoD9UVsnxm93G4eM6h7N-3WO&_nc_zt=23&_nc_ht=scontent-cdg4-1.xx&_nc_gid=7XhJu625MGzN-M9b3WieuA&_nc_ss=7a3a8&oh=00_Af05qmSM6ol-IP7B3SyWpp1sP7cuEKAEKum7YGUVHRg28Q&oe=69E963B4'),
(132, 'Kapuchon (Afrojack)', '', 'https://i1.wp.com/www.festivalling.com/wp-content/uploads/2020/11/Afrojack-aka-Kapuchon.jpg?fit=1200%2C800&ssl=1'),
(133, 'Bebe Rexha', 'F', 'https://alexandermagazin.com/wp-content/uploads/2026/02/bebe-rexha-new-album-dirty-blonde-announcement-1920x1281.jpg'),
(134, 'John Martin', 'H', 'https://upload.wikimedia.org/wikipedia/commons/8/82/John_Martin_By_Daniel_%C3%85hs_Karlsson.jpg');

-- --------------------------------------------------------

--
-- Structure de la table `association`
--

CREATE TABLE `association` (
  `idAsso` int(11) NOT NULL,
  `evenement` int(11) NOT NULL,
  `artiste` int(11) NOT NULL,
  `pPartie` varchar(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `association`
--

INSERT INTO `association` (`idAsso`, `evenement`, `artiste`, `pPartie`) VALUES
(1, 1, 13, 'N'),
(2, 2, 1, 'N'),
(3, 29, 60, 'N'),
(4, 3, 4, 'N'),
(5, 3, 5, 'N'),
(13, 3, 7, 'N'),
(15, 3, 9, 'N'),
(16, 3, 10, 'N'),
(17, 4, 5, 'N'),
(18, 4, 14, 'N'),
(19, 4, 15, 'N'),
(20, 4, 16, 'N'),
(21, 4, 17, 'N'),
(22, 4, 18, 'N'),
(23, 5, 11, 'N'),
(24, 5, 12, 'O'),
(25, 8, 1, 'N'),
(26, 8, 20, 'N'),
(27, 9, 2, 'N'),
(28, 8, 69, 'O'),
(29, 8, 68, 'O'),
(30, 9, 28, 'O'),
(31, 10, 26, 'N'),
(32, 10, 27, 'O'),
(33, 11, 19, 'N'),
(34, 11, 20, 'N'),
(35, 11, 21, 'N'),
(36, 11, 22, 'N'),
(37, 11, 23, 'N'),
(38, 11, 24, 'N'),
(39, 11, 25, 'N'),
(40, 12, 42, 'N'),
(41, 12, 43, 'N'),
(42, 12, 44, 'N'),
(43, 12, 45, 'N'),
(44, 12, 30, 'N'),
(45, 12, 34, 'N'),
(46, 13, 18, 'N'),
(47, 14, 53, 'N'),
(48, 14, 54, 'O'),
(49, 14, 29, 'O'),
(50, 15, 47, 'N'),
(51, 15, 20, 'N'),
(52, 15, 48, 'N'),
(53, 16, 49, 'N'),
(54, 16, 50, 'N'),
(55, 16, 51, 'N'),
(56, 16, 11, 'N'),
(57, 16, 52, 'N'),
(58, 17, 41, 'N'),
(59, 18, 39, 'N'),
(60, 18, 40, 'O'),
(61, 19, 33, 'N'),
(62, 19, 34, 'N'),
(63, 19, 35, 'N'),
(64, 19, 36, 'N'),
(65, 19, 37, 'N'),
(66, 19, 38, 'N'),
(67, 20, 30, 'N'),
(68, 20, 31, 'O'),
(69, 20, 32, 'O'),
(70, 7, 32, 'N'),
(71, 37, 62, 'N'),
(72, 7, 71, 'N'),
(73, 7, 72, 'N'),
(74, 7, 44, 'N'),
(75, 7, 73, 'N'),
(76, 7, 74, 'N'),
(77, 7, 8, 'N'),
(78, 21, 46, 'N'),
(79, 22, 65, 'N'),
(80, 22, 66, 'N'),
(81, 22, 67, 'N'),
(82, 23, 55, 'N'),
(83, 24, 56, 'N'),
(84, 25, 57, 'N'),
(85, 25, 58, 'N'),
(86, 25, 59, 'N'),
(87, 25, 56, 'N'),
(88, 26, 60, 'N'),
(89, 27, 61, 'N'),
(90, 28, 62, 'N'),
(91, 29, 63, 'N'),
(92, 30, 64, 'N'),
(93, 31, 33, 'N'),
(118, 3, 75, 'N'),
(119, 5, 82, 'O'),
(128, 6, 3, 'N'),
(129, 6, 6, 'N'),
(130, 6, 8, 'N'),
(131, 6, 79, 'N'),
(132, 6, 78, 'N'),
(133, 6, 74, 'N'),
(134, 6, 76, 'N'),
(135, 6, 77, 'N'),
(136, 33, 86, 'N'),
(137, 34, 84, 'N'),
(138, 34, 85, 'O'),
(139, 35, 81, 'N'),
(140, 35, 80, 'N'),
(141, 36, 19, 'N'),
(142, 36, 83, 'N'),
(144, 32, 79, 'N'),
(145, 32, 87, 'N'),
(146, 32, 88, 'N'),
(147, 32, 89, 'N'),
(148, 32, 90, 'N'),
(149, 38, 18, 'N'),
(150, 38, 72, 'N'),
(151, 38, 70, 'N'),
(152, 38, 64, 'N'),
(153, 38, 95, 'N'),
(154, 38, 83, 'N'),
(155, 39, 88, 'N'),
(156, 36, 102, 'O'),
(157, 38, 104, 'O'),
(158, 38, 103, 'O'),
(159, 38, 105, 'O'),
(160, 38, 106, 'O'),
(161, 38, 107, 'O'),
(162, 38, 99, 'O'),
(163, 38, 98, 'O'),
(165, 11, 97, 'O'),
(166, 11, 99, 'O'),
(167, 11, 98, 'O'),
(168, 40, 108, 'N'),
(169, 1, 109, 'O'),
(170, 1, 7, 'O'),
(171, 37, 110, 'O'),
(172, 1, 111, 'O'),
(173, 1, 112, 'O'),
(174, 1, 113, 'O'),
(175, 1, 114, 'O'),
(176, 1, 115, 'O'),
(177, 1, 116, 'O'),
(178, 39, 79, 'N'),
(179, 39, 89, 'N'),
(180, 39, 70, 'N'),
(181, 39, 117, 'O'),
(182, 39, 118, 'O'),
(183, 39, 119, 'N'),
(184, 39, 120, 'N'),
(186, 32, 122, 'N'),
(187, 32, 123, 'N'),
(188, 32, 124, 'N'),
(189, 32, 125, 'N'),
(190, 2, 89, 'O'),
(191, 43, 1, 'N'),
(192, 44, 3, 'N'),
(193, 43, 126, 'O'),
(194, 45, 103, 'N'),
(195, 33, 127, 'O'),
(196, 46, 8, 'N'),
(197, 46, 24, 'N'),
(198, 46, 117, 'N'),
(199, 47, 73, 'N'),
(204, 46, 70, 'N'),
(205, 46, 129, 'N'),
(206, 46, 130, 'N'),
(207, 46, 128, 'N'),
(208, 48, 1, 'N'),
(209, 50, 16, 'N'),
(210, 46, 107, 'O'),
(211, 46, 99, 'O'),
(212, 46, 98, 'O'),
(213, 46, 104, 'O'),
(214, 46, 131, 'O'),
(215, 46, 132, 'O'),
(216, 46, 134, 'O'),
(217, 46, 133, 'O');

-- --------------------------------------------------------

--
-- Structure de la table `categorie`
--

CREATE TABLE `categorie` (
  `idCat` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nomCat` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `categorie`
--

INSERT INTO `categorie` (`idCat`, `nomCat`) VALUES
('CARO', 'Carré Or'),
('CAT1', 'Cat 1'),
('CAT2', 'Cat 2'),
('CAT3', 'Cat 3'),
('CAT4', 'Cat 4'),
('FOSS', 'Fosse'),
('GRAD', 'Gradin');

-- --------------------------------------------------------

--
-- Structure de la table `evenement`
--

CREATE TABLE `evenement` (
  `idEvent` int(11) NOT NULL,
  `nomEvent` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` date NOT NULL,
  `lieu` int(11) NOT NULL,
  `type` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `placement` varchar(4) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pPartie` int(11) DEFAULT NULL,
  `affiche` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `cover` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `prixBillet` double NOT NULL,
  `depenseSup` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `evenement`
--

INSERT INTO `evenement` (`idEvent`, `nomEvent`, `date`, `lieu`, `type`, `placement`, `pPartie`, `affiche`, `cover`, `prixBillet`, `depenseSup`) VALUES
(1, 'DJ Snake : The Final Show', '2025-05-10', 2, 'CON', 'CAT1', 0, 'https://pbs.twimg.com/media/GAQEeS9W8AAGhwo.jpg:large', 'https://static.cnews.fr/sites/default/files/000_468n6kd_681fb6b94fa80.jpg', 86, 34.5),
(2, 'David Guetta : The Monolyth Tour', '2025-06-21', 1, 'CON', 'CAT1', 0, 'https://www.myprovence.fr/sites/default/files/poi/6922678/22418411_2024-05-21T07204911700022828707.jpg', 'https://dynamicmedia.livenationinternational.com/e/s/j/1a092c1e-d458-4b03-b32f-744807fe5951.jpg', 70.5, 132),
(3, 'Amsterdam Music Festival 2024', '2024-10-19', 4, 'FES', 'FOSS', 0, 'https://www.prysmradio.com/wp-content/uploads/2024/09/AMF-2024-FULL-Line-up-instagram-DJ-mag-portrait-1080x1350-1.jpg', 'https://amf-festival.com/wp-content/uploads/2024/10/241020-014817-AMF2024-8660-TD-scaled.jpg', 87, 173),
(4, 'Touquet Music Beach Festival', '2023-08-26', 11, 'FES', 'FOSS', 0, 'https://sortir-prod.s3-eu-west-1.amazonaws.com/uploads/events/covers/medium/9a6aaecacdeffd85f5a92bc43333119e8979296a.jpg?1685020299', 'https://handsupelectro.fr/wp-content/uploads/2023/09/pPIwGANY.jpeg', 55, 0),
(5, 'Kygo World Tour', '2024-12-07', 3, 'CON', 'CAT2', 0, 'https://img.nrj.fr/hbapIt-iTkqsOK-XGlOroSUQZHQ=/medias%2F2024%2F04%2F3vud7ajqftqosz5a4eo4f7unbnyqykx5ko6nlleknia_662661b2462d8.jpg', 'https://assets0.dostuffmedia.com/uploads/aws_asset/aws_asset/21733568/b2558e74-2529-41db-bade-31283c56e76b.jpg', 69, 6.8),
(6, 'Tomorrowland Our Story', '2024-10-18', 5, 'SOI', 'GRAD', 0, 'https://cdn.uc.assets.prezly.com/31de40c1-7815-4643-9cb6-1e251c06fd44/-/resize/1108x/-/quality/best/-/format/auto/', 'https://prismic-assets-cdn.tomorrowland.com/Zynq_q8jQArT0MNT_241018-234230-TML_OURSTORY-08453-HR-JT-min.jpg?width=1600', 55, 0),
(7, 'Tomorrowland Belgique 2024 Lyfe', '2024-07-20', 6, 'FES', 'FOSS', 0, 'https://akkros.com/images/voyages/tomorrowland_weekend_2_2024.png?6519177', 'https://cdn.uc.assets.prezly.com/aabab785-d885-4a23-9191-ac86a2bc8afb/-/preview/1200x1200/-/format/auto/', 159, 0),
(8, 'David Guetta : Chambord Live', '2024-06-29', 7, 'FES', 'FOSS', 0, 'https://cdn1.chambord.org/fr/wp-content/uploads/sites/2/2023/12/affiche.jpg', 'https://cdn.prod.website-files.com/6478537901c5003e7d5b2d14/66a0f3f5d3adc04daa084728_20240629223801__M9A8315.jpg', 79, 66),
(9, 'Taylor Swift : The Eras Tour', '2024-06-03', 8, 'CON', 'CAT3', 0, 'https://img.leboncoin.fr/api/v1/lbcpb1/images/82/cf/30/82cf30939c271ad3f4f187ec258d8b9f06cd4f4e.jpg?rule=ad-image', 'https://resize.programme-television.org/original/var/premiere/storage/images/news/streaming/disney-plus/taylor-swift-the-eras-tour-le-film-de-la-tournee-historique-cree-l-evenement-sur-disney-video-4725922/102763852-1-fre-FR/Taylor-Swift-The-Eras-Tour-le-film-de-la-tournee-historique-cree-l-evenement-sur-Disney-VIDEO.jpg', 91, 44),
(10, 'Tate McRae : Think Later Tour', '2024-04-30', 9, 'CON', 'FOSS', 0, 'https://images.lesindesradios.fr/fit-in/1100x2000/filters:format(webp)/medias/7cwFGTQgm9/image/Tate_21701891164118.jpg', 'https://www.instyle.com/thmb/o14JY9or4AqVccGZ0VizjWR68a0=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/GettyImages-2161719037-d91213d43cbe4fe8a811a54b28892b1d.jpg', 43, 37.5),
(11, 'Fun Radio Ibiza Experience 2024', '2024-04-05', 3, 'FES', 'FOSS', 0, 'https://cmsphoto.ww-cdn.com/superstatic/36765/art/grande/77904664-56581509.jpg?v=1705739780', 'https://images.rtl.fr/~c/1200v800/funradio/www/1667838-martin-solveig-mixe-a-l-accor-arena.jpeg', 62, 37.5),
(12, 'Fun Radio Ibiza Experience 2023', '2023-04-28', 3, 'FES', 'GRAD', 0, 'https://images.rtl.fr/funradio/www/1578525-frie.jpg', 'https://images.rtl.fr/~c/2000v2000/funradio/www/1444199-l-edition-2019-de-fun-radio-ibiza-experience.jpg', 57, 65.5),
(13, 'Ofenbach : One live', '2023-10-28', 10, 'CON', 'FOSS', 0, 'https://assets.leparisien.fr/website/etudiant/evenements/recto_flyer/2023/10/2726055_ofenbach-zenith.jpg', 'https://images.lesindesradios.fr/filters:format(webp)/medias/Vsj0LZpM34/image/Capture_d_e_cran_2024_05_24_a__15_19_001716556803970-format16by9.png', 44, 0),
(14, 'The Weeknd : The After Hours Til Dawn Tour', '2023-07-29', 2, 'CON', 'CAT2', 0, 'https://files.offi.fr/programmation/2164809/images/600/5bef015967210f7fc4c3022bfa266835.jpg', 'https://awardsradar.com/wp-content/uploads/2023/06/the-weeknd-live-at-sofi-stadium_0-1.jpg', 110, 0),
(15, 'Main Square 2023', '2023-06-30', 13, 'FES', 'FOSS', 0, 'https://www.concerts-metal.com/images/flyers/202303/1679387514.webp', 'https://lvdneng.rosselcdn.net/sites/default/files/dpistyles_v2/vdn_864w/2023/07/01/node_1347182/56351695/public/2023/07/01/B9734653191Z.1_20230701002608_000%2BGD9N2G5B5.4-0.jpg?itok=LgFsnYPJ1688194571', 69, 7.8),
(16, 'Lollapalooza 2023', '2023-07-22', 12, 'FES', 'FOSS', 0, 'https://leclaireur.fnac.com/wp-content/uploads/2022/12/lollapalooza-paris-724x1024.jpg', 'https://www.frequence3.com/wp-content/uploads/2023/04/Lollapalooza-Paris-2023.png', 89, 56),
(17, 'Ava Max : On tour (Finally)', '2023-04-24', 14, 'CON', 'FOSS', 0, 'https://img.nrj.fr/9W3ij1n7Fffdiua9ewpI3mi4aAA=/medias%2F2023%2F02%2Ftl0sv75y08mjafzq8utmvedypkporspz8s21mncgtei_63fc850f147a7.jpg', 'https://variety.com/wp-content/uploads/2022/12/CJP18267-1.jpg', 29, 0),
(18, 'Nonante-cinq Tour', '2022-11-21', 15, 'CON', 'FOSS', 0, 'https://www.label-ln.fr/images/images_spectacles/spectacle502_detail.jpg', 'https://cloudfront-eu-central-1.images.arcpublishing.com/leparisien/AVLA3VGDXVD37NI4RRJFESMQBM.jpg', 39, 0),
(19, 'Paranormal Festival', '2022-10-27', 15, 'FES', 'FOSS', 0, 'https://cdn.prod.website-files.com/60df1b26ef94b3de3f751a57/634fe00ea4de6e7cae48d241_paranormal-festival-20220920170333.jpg', 'https://res.cloudinary.com/shotgun/image/upload/v1664199305/production/artworks/Paranormal_cover_svj5oy.jpg', 30, 0),
(20, 'Walkerverse Tour', '2022-10-01', 14, 'CON', 'FOSS', 0, 'https://www.clickmagazine.co.uk/wp-content/uploads/2022/05/7dfab1f8-6749-8eb4-aa85-8da057511196-1024x1024.png', 'https://rollingstoneindia.com/wp-content/uploads/2023/07/Alan-Walker-live.jpg', 36, 0),
(21, 'Les Briques Rouges 2023', '2022-09-23', 16, 'FES', 'FOSS', 0, 'https://lh4.googleusercontent.com/proxy/xwFnRlcnFM2GI7sZG3lQXHvG0r4vCryURzEff7UhOfRJ-BPoMtjXtFq-wLBVEBEfIa04OXq0-Om6HglNLvIM3pRFdL3ZOZZnTJw', 'https://www.lesbriquesrouges.fr/_nuxt/img/qui-sommes-nous1.c829b90.jpg', 31, 0),
(22, 'Europe 1 Tourcoing', '2022-09-16', 17, 'FES', 'FOSS', 0, 'https://www.zoomsurlille.fr/wp-content/uploads/2023/05/europe_2_live_01.jpg', 'https://lvdneng.rosselcdn.net/sites/default/files/dpistyles_v2/ena_16_9_extra_big/2024/06/05/node_1469409/59181329/public/2024/06/05/18922100.jpeg?itok=Gnu6fGPZ1717614520', 0, 0),
(23, 'Robin des bois', '2014-02-09', 15, 'COM', 'GRAD', 0, 'https://static.fnac-static.com/multimedia/Images/FR/NR/6f/e8/5f/6285423/1507-1/tsp20140912102038/Robin-des-bois-DVD.jpg', 'https://cdn-s-www.leprogres.fr/images/47B592A5-8909-4B40-83F3-0736CCE91150/NW_raw/photo-dr-1389731138.jpg', 45, 0),
(24, 'A l\'infini Tour', '2014-03-22', 15, 'CON', 'GRAD', 0, 'https://www.cgrevents.com/sites/default/files/concert_tal.jpg', 'https://medias.objectifgard.com/api/v1/images/view/636b584254b1310ed6344e66/article/image.jpg', 39, 0),
(25, 'Fourmies live', '2015-07-03', 18, 'FES', 'FOSS', 0, 'https://storage.canalblog.com/52/99/783846/105057230_o.jpg', 'https://live.staticflickr.com/8888/28201662896_fd8ea9a0ab_h.jpg', 29, 0),
(26, 'Black M', '2019-08-15', 13, 'CON', 'FOSS', 0, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTSRcmJh8Lh8sVzStOw15cfz6oTzy4ocW13Tg&s', 'https://lvdneng.rosselcdn.net/sites/default/files/dpistyles_v2/vdn_864w/2019/08/16/node_625334/40455249/public/2019/08/16/B9720584720Z.1_20190816003243_000%2BGCJE8L109.3-0.jpg?itok=AtWEWDzR1565942462', 0, 0),
(27, 'Aya Nakamura', '2019-10-20', 19, 'SHO', 'FOSS', 0, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrxUR3dYRZ3FNEr0nGLnezAgDUh0iHzcwQWQ&s', 'https://static.actu.fr/uploads/2019/11/aya-nakamura-cours-de-danse-gare-saint-sauveur-bistrot-st-so-lille.jpg', 0, 0),
(28, 'Future Nostalgia Tour', '2022-05-07', 20, 'CON', 'GRAD', 0, 'https://upload.wikimedia.org/wikipedia/en/8/8f/Future_Nostalgia_Tour_poster.png', 'https://www.kekelmb.com/wp-content/uploads/2022/03/kekeLMB_DuaLipa_FutureNostalgiaTour_PrudentialCenter_Newark_2022_gallery-32.jpg', 85.5, 0),
(29, 'La tournée événement sexion d\'assaut', '2022-06-12', 15, 'CON', 'FOSS', 0, 'https://media.senscritique.com/media/000020762009/300/session_d_assaut_le_concert_evenement.jpg', 'https://images.laprovence.com/media/hermes/2022-06/2022-06-13/20220613_1_6_1_1_0_obj26322322_1.jpg?twic=v1/crop=1800x990@0x266/cover=820x461', 49, 0),
(30, 'Robin Schuldz', '2022-08-11', 21, 'SHO', 'FOSS', 0, 'https://icisete.fr/wp-content/uploads/2023/11/DJ-Robin-Schulz-Amnesia-Cap-dAgde.jpg', 'https://valliue.com/wp-content/uploads/2019/06/amnesia.jpg', 21, 0),
(31, 'DJ Bens', '2022-08-21', 21, 'SHO', 'FOSS', 0, 'https://icisete.fr/wp-content/uploads/2023/11/Dj-Bens-Amnesia-Cap-dAgde.jpg', 'https://valliue.com/wp-content/uploads/2019/06/amnesia.jpg', 21, 0),
(32, 'Tomorrowland Belgique 2025 Orbyz', '2025-07-25', 6, 'FES', 'FOSS', 0, 'https://cdn.uc.assets.prezly.com/3e9bda7e-8dc4-4cf9-aa3d-72867a46e256/-/resize/1108x/-/quality/best/-/format/auto/', 'https://www.djmag.fr/wp-content/uploads/2025/07/250720-210345-TOMORROWLAND25-DN-HR-scaled.jpg', 227.5, 45),
(33, 'Katy Perry : The Lifetimes Tour', '2025-10-24', 3, 'CON', 'CAT3', 0, 'https://pbs.twimg.com/media/Gemni4oWwAEc8_c?format=jpg&name=large', 'https://www.kiis1065.com.au/wp-content/uploads/sites/2/2025/06/Photo-Jun-05-2025-1-35-42-AM-10-1.jpg', 67, 40.99),
(34, 'Imagne Dragon : Loom World Tour', '2025-07-23', 22, 'CON', 'CAT4', 0, 'https://i.ebayimg.com/images/g/gRsAAOSw8l9mybQO/s-l1600.jpg', 'https://www.eventim.de/obj/media/DE-eventim/teaser/artworks/2024/imagine-dragons-tickets-header.jpg', 85, 0),
(35, '30 ans Zenith Lille', '2024-11-26', 15, 'CON', 'FOSS', 0, 'https://www.zoomsurlille.fr/wp-content/uploads/2024/09/feder_lgp_30_ans_02.jpg', 'https://www.lille.fr/var/www/storage/images/mediatheque/mairie-de-lille/actualites/objets-multimedia/galeries-d-images/2024/novembre-2024/soiree-des-30-ans-de-lille-grand-palais/soiree-des-30-ans-de-lille-grand-palais3/3640130-1-fre-FR/Soiree-des-30-ans-de-Lille-Grand-Palais_news_image_top.jpg', 0, 0),
(36, 'Meduza & James Hype Present Our House', '2025-04-04', 24, 'SOI', 'FOSS', 0, 'https://cdn.sanity.io/images/ifm9m55z/production/97e6435c158d5022c0b271a5e41c1ddebb1e5a92-1920x1080.jpg?w=640&h=1138&fit=crop&auto=format&q=75', 'https://res.cloudinary.com/shotgun/image/upload/c_limit,w_3840/fl_lossy/f_auto/q_auto/production/artworks/FLYER_PHANTOM_ybnb0a.jpg', 30, 0),
(37, 'Dua Lipa : Radical Optimism Tour', '2025-05-23', 23, 'CON', 'CAT2', 0, 'https://img.nrj.fr/R9aQyZ3eY_HbLKsO9HxB2tK33BU=/medias%2F2024%2F09%2Fttueonff6tipuk3odh2uemftkygoimy5n4j6lzufhoe_66e4066cf30b3.jpg', 'https://www.datocms-assets.com/44039/1748059370-img_8848.jpeg?auto=format%2Ccompress&cs=srgb', 84, 26.5),
(38, 'Fun Radio Ibiza Experience 2025', '2025-04-04', 3, 'FES', 'FOSS', 0, 'https://evenement.juliengournay.fr/img/fun_radio_ibiza_2025.jpg', 'https://images.rtl.fr/~c/1155v769/funradio/www/1747219-la-sublime-scene-de-fun-radio-ibiza-experience-2025.jpeg', 63, 26.48),
(39, 'Amsterdam Music Festival 2025', '2025-10-25', 4, 'FES', 'FOSS', 0, 'https://amf-festival.com/wp-content/uploads/2024/06/221023-025042-AMF2022-_HLZ5913-HL.jpg', 'https://amf-festival.com/wp-content/uploads/2025/10/20251026_0025_AMF_BRADAMEDIA_JORDYBRADA_9405-kopie.jpg', 116.84, 188),
(40, '14 Juillet - Marcq en Baroeul', '2016-07-14', 25, 'SOI', 'FOSS', 0, 'https://lvdneng.rosselcdn.net/sites/default/files/dpistyles_v2/vdn_864w/2024/07/12/node_1482715/59734215/public/2024/07/12/21301118.jpeg?itok=9WfhiCaP1720773383', 'https://i0.wp.com/lessortiesdunelilloise.fr/wp-content/uploads/2024/06/1200x680_maxpeopleworldtwo030120.webp?resize=1140%2C646&ssl=1', 0, 0),
(43, 'David Guetta : The Ultimate Monolith Show', '2026-06-12', 2, 'CON', 'CAT1', NULL, 'https://www.guettapen.com/wp-content/uploads/2025/09/snapins-ai_3724545739364909837-819x1024.jpg', 'https://www.guettapen.com/wp-content/uploads/2025/06/Guettavel-23-1024x683.jpg', 82, 0),
(44, 'Symphony of Unity', '2025-11-11', 26, 'CON', 'GRAD', NULL, 'https://cdn.uc.assets.prezly.com/c30ab5dd-4cf0-4490-81cc-815f80a56d26/-/resize/1108x/-/quality/best/-/format/auto/', 'https://weraveyou.com/wp-content/uploads/2025/07/Symphony-of-Unity-scaled.jpg', 50, 0),
(45, 'Gims : le dernier tour', '2025-07-14', 27, 'SOI', 'FOSS', NULL, 'https://www.valenciennes.fr/wp-content/uploads/2025/06/14-juillet-gims-1080x1920--576x1024.jpg', 'https://sfractus-images.cleo.media/unsafe/0x200:2048x1352/2000x0/images/Le-rappeur-GIMS-12793.jpg', 0, 0),
(46, 'Fun Radio Ibiza Experience 2026', '2026-04-17', 3, 'FES', 'FOSS', 0, 'https://just-music.fr/wp-content/uploads/2026/02/Fun-Radio-Ibiza-Experience-JustMusic.fr_-1.png', 'https://www.guettapen.com/wp-content/uploads/2024/12/248165164_4372532982838708_6572106243368328487_n.jpg', 67, 34.41),
(47, 'Anyma : ÆDEN World Tour', '2026-06-06', 28, 'CON', 'FOSS', NULL, 'https://agendabrussels2.imgix.net/1a29bd1d06800f09d7da8808ab572d19121cd293.jpg?w=654&h=925&fit=clip', 'https://images.squarespace-cdn.com/content/v1/668f83b1434d1b695f80dde1/a5373dea-da96-4adf-b0b2-d8799c03ef90/ANYMA-AEDEN-GLOBAL-FINAL-_06.jpg', 67, 0),
(48, 'Amsterdam Music Festival 2026', '2026-10-24', 4, 'FES', 'FOSS', 0, 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS_FBr0HT9jC-AUY8C-TNTH88VIsF47W_67JjXrxLV4HAhxl11i_KpP2_Nd&s=10', 'https://amf-festival.com/wp-content/uploads/2025/10/20251026_0025_AMF_BRADAMEDIA_JORDYBRADA_9405-kopie.jpg', 96.5, 0),
(50, 'Mosimann', '2027-10-16', 3, 'CON', 'CARO', NULL, 'https://www.guettapen.com/wp-content/uploads/2026/04/Format_instagram_3_4-768x1024.jpg', 'https://imgproxy.ra.co/_/rt:fill/h:630/w:1200/quality:50/aHR0cHM6Ly9pbWFnZXMucmEuY28vNGVhZmQ0MjE3NGY5OGExMjVkZWFjYTllOWQ4MzQ2MTZiOGY5OGQxOS5wbmc=', 75, 0);

-- --------------------------------------------------------

--
-- Structure de la table `lieu`
--

CREATE TABLE `lieu` (
  `idLieu` int(11) NOT NULL,
  `nomLieu` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ville` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `pays` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `photoLieu` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `lieu`
--

INSERT INTO `lieu` (`idLieu`, `nomLieu`, `ville`, `pays`, `photoLieu`) VALUES
(1, 'Vélodrome Orange', 'Marseille', 'France', 'https://leclaireur.fnac.com/wp-content/uploads/2024/04/velodrome-stade-1256x826.jpg'),
(2, 'Stade de France', 'Saint-Denis', 'France', 'https://www.franceguide.info/fr/wp-content/uploads/sites/20/paris-stade-de-france-outdoor-hd.jpg'),
(3, 'Accor Arena', 'Paris', 'France', 'https://econoviagroup.fr/wp-content/uploads/2019/11/HP-AccorHotels-Arena-Paris-France.jpg'),
(4, 'Johan Cruijff Arena', 'Amsterdam', 'Pays-Bas', 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/6f/df/b7/caption.jpg?w=1200&h=-1&s=1'),
(5, 'Ziggo Dome', 'Amsterdam', 'Pays-Bas', 'https://d1ize34iqy408p.cloudfront.net/images/ZiggoDome-2016_verkleind.width-2560.webp'),
(6, 'Domaine provincial De Schorre', 'Boom', 'Belgique', 'https://climbfinder.com/CDN/de-schorre-boom-upload-6192-1024x0.jpg'),
(7, 'Chateau de Chambord', 'Chambord', 'France', 'https://www.val-de-loire-41.com/wp-content/uploads/2023/10/chambord-septembre-2023-dnc-olivier-marchant-1-1600x900.jpg'),
(8, 'Groupama Stadium', 'Lyon', 'France', 'https://media.lyon-france.com/1280x764/5042888/9983786.jpg'),
(9, 'Lotto Arena', 'Anvers', 'Belgique', 'https://antwerpconventionbureau.be/_next/image?url=https%3A%2F%2Fdonkeycomm-1.ams3.digitaloceanspaces.com%2Fantwerpconventionbureau-strapi%2FACB_lotto_arena_81a0493a3b.jpg&w=3840&q=75'),
(10, 'Zenith Paris La Villette', 'Paris', 'France', 'https://www.businessprofilers.com/produit/images/960x480/le_zenith_paris_la_villette_12279/facade/le_zenith_paris_la_villette_facade_1.jpg'),
(11, 'L\'Orangerie de la Baie', 'Le Touquet Paris Plage', 'France', 'https://phrnleng.rosselcdn.net/sites/default/files/dpistyles_v2/ena_16_9_extra_big/2023/07/07/node_179063/3318225/public/2023/07/07/B9734694185Z.1_20230707151440_000%2BG4SN2P0D3.1-0.jpg?itok=DotGFblu1688735689'),
(12, 'Hippodrome Paris Longchamp', 'Paris', 'France', 'https://www.oteis.fr/wp-content/uploads/2016/03/photo_1.jpg'),
(13, 'Citadelle d Arras', 'Arras', 'France', 'https://www.arrasville.fr/wp-content/uploads/2022/05/porte-quartier-turenne-citadelle-arras.jpg'),
(14, 'Ancienne Belgique', 'Bruxelles', 'Belgique', 'https://www.abconcerts.be/media/cache/ogimage/upload/media/default/ae/bac1fb6bb046353975be4e56a0737cf47b820a13.jpg'),
(15, 'Zenith Lille', 'Lille', 'France', 'https://upload.wikimedia.org/wikipedia/commons/1/18/Z%C3%A9nith_de_Lille_2014.JPG'),
(16, 'Château Dalle Dumont', 'Wervicq-Sud', 'France', 'https://www.wervicq-sud.com/wp-content/uploads/2021/02/chateau-et-parc-dalle-dumont.jpg'),
(17, 'Parvis St Christophe', 'Tourcoing', 'France', 'https://locations.filmfrance.net/sites/default/files/photos/ville-de-tourcoing-centre-127889/photo165696.jpg'),
(18, 'Site des Verreries', 'Fourmies', 'France', 'https://www.fourmies.fr/upload/sliders/34229_IMG-6915.jpg'),
(19, 'Euralille', 'Lille', 'France', 'https://lh3.googleusercontent.com/p/AF1QipPUcK3DazVCKygxCYxp8eZTwrl8qZIiKTQj9VAP=s680-w680-h510'),
(20, 'Sportpaleis Antwerpen', 'Anvers', 'Belgique', 'https://img.standaard.be/E2OlX4lDJ6krgtPT8EtxkBydniU=/640x427/smart/https%3A%2F%2Fstatic.standaard.be%2FAssets%2FImages_Upload%2F2014%2F01%2F31%2Fea58a3b6-8a98-11e3-a965-d230c9a3b817_web_scale_0.0976563_0.0976563__.jpg'),
(21, 'Amnésia', 'Cap d Agde', 'France', 'https://cdn-s-www.lejsl.com/images/222ae107-cb8e-497e-8fa6-9a09c961cd67/NW_raw/gregory-boudou-est-le-gerant-de-la-discotheque-l-amnesia-fondee-par-son-pere-andre-boudou-au-cap-d-agde-photo-afp-1522871600.jpg'),
(22, 'Décathlon Aréna Stade Pierre Mauroy', 'Lille', 'France', 'https://www.ostadium.com/galleries/stade-pierre-mauroy-illus.jpg'),
(23, 'La Défense Arena', 'Nanterre', 'France', 'https://thumbs.dreamstime.com/b/vue-ext%C3%A9rieure-sur-paris-la-d%C3%A9fense-arena-stade-et-salle-de-concert-nanterre-france-octobre-l-ar%C3%A8ne-le-est-un-une-polyvalents-293087450.jpg'),
(24, 'Phantom Accor Arena', 'Paris', 'France', 'https://i0.wp.com/paris-society.com/fr/uploads/sites/2/2024/04/02-Phantom-Club.jpg?ssl=1&w=2500&quality=85'),
(25, 'Hippodrome Croisé-Laroche', 'Marcq en Baroeul', 'France', 'https://www.lilleevents.fr/wp-content/uploads/2020/10/PHOTOO-HIPPODROME3.png'),
(26, 'Antwerp Expo', 'Anverse', 'Belgique', 'https://cdn.eventplanner.fr/imgs/adv-92/15316-img-desktop-antwerp-expo@2x.jpg'),
(27, 'Parking Lacuzon', 'Valenciennes', 'France', 'https://www.citecongresvalenciennes.com/wp-content/uploads/2025/03/1.Valenciennes-place-darmes-hotel-de-ville-OTCVM-%C2%A9-claude.waeghemacker-HD-130.jpg'),
(28, 'Parc du Cinquantenaire', 'Bruxelles', 'France', 'https://images.lecho.be/view?iid=Elvis:4wXTgmYQKaQA71oP6_FdTD&context=ONLINE&ratio=16/9&width=1280&u=1648705258000');

-- --------------------------------------------------------

--
-- Structure de la table `type`
--

CREATE TABLE `type` (
  `idType` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `nomType` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Déchargement des données de la table `type`
--

INSERT INTO `type` (`idType`, `nomType`) VALUES
('COM', 'Comédie musicale'),
('CON', 'Concert'),
('FES', 'Festival'),
('SHO', 'Showcase'),
('SOI', 'Soirée');

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `artiste`
--
ALTER TABLE `artiste`
  ADD PRIMARY KEY (`idArtiste`);

--
-- Index pour la table `association`
--
ALTER TABLE `association`
  ADD PRIMARY KEY (`idAsso`),
  ADD KEY `Association_evenement_fkey` (`evenement`),
  ADD KEY `Association_artiste_fkey` (`artiste`);

--
-- Index pour la table `categorie`
--
ALTER TABLE `categorie`
  ADD PRIMARY KEY (`idCat`);

--
-- Index pour la table `evenement`
--
ALTER TABLE `evenement`
  ADD PRIMARY KEY (`idEvent`),
  ADD KEY `Evenement_lieu_fkey` (`lieu`),
  ADD KEY `Evenement_type_fkey` (`type`),
  ADD KEY `placement` (`placement`);

--
-- Index pour la table `lieu`
--
ALTER TABLE `lieu`
  ADD PRIMARY KEY (`idLieu`);

--
-- Index pour la table `type`
--
ALTER TABLE `type`
  ADD PRIMARY KEY (`idType`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `artiste`
--
ALTER TABLE `artiste`
  MODIFY `idArtiste` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=135;

--
-- AUTO_INCREMENT pour la table `association`
--
ALTER TABLE `association`
  MODIFY `idAsso` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=218;

--
-- AUTO_INCREMENT pour la table `evenement`
--
ALTER TABLE `evenement`
  MODIFY `idEvent` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT pour la table `lieu`
--
ALTER TABLE `lieu`
  MODIFY `idLieu` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `association`
--
ALTER TABLE `association`
  ADD CONSTRAINT `association_ibfk_1` FOREIGN KEY (`artiste`) REFERENCES `artiste` (`idArtiste`),
  ADD CONSTRAINT `association_ibfk_2` FOREIGN KEY (`evenement`) REFERENCES `evenement` (`idEvent`);

--
-- Contraintes pour la table `evenement`
--
ALTER TABLE `evenement`
  ADD CONSTRAINT `evenement_ibfk_1` FOREIGN KEY (`lieu`) REFERENCES `lieu` (`idLieu`),
  ADD CONSTRAINT `evenement_ibfk_2` FOREIGN KEY (`type`) REFERENCES `type` (`idType`),
  ADD CONSTRAINT `evenement_ibfk_3` FOREIGN KEY (`placement`) REFERENCES `categorie` (`idCat`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
