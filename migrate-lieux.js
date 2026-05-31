/**
 * Import des lieux depuis l'ancienne BDD SQL vers Firebase Firestore.
 * Usage : node migrate-lieux.js [uid]
 *   Si uid est omis, le script prend le premier compte Firebase Auth trouvé.
 */

const admin = require('firebase-admin');
const serviceAccount = require('./concertotheque-firebase-adminsdk-fbsvc-3b05196fad.json');

admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
const db = admin.firestore();

// ── Données extraites de evenement.sql ────────────────────────────────────────
const lieux = [
  { nom: 'Vélodrome Orange',              ville: 'Marseille',              pays: 'France',     photo: 'https://leclaireur.fnac.com/wp-content/uploads/2024/04/velodrome-stade-1256x826.jpg' },
  { nom: 'Stade de France',               ville: 'Saint-Denis',            pays: 'France',     photo: 'https://www.franceguide.info/fr/wp-content/uploads/sites/20/paris-stade-de-france-outdoor-hd.jpg' },
  { nom: 'Accor Arena',                   ville: 'Paris',                  pays: 'France',     photo: 'https://econoviagroup.fr/wp-content/uploads/2019/11/HP-AccorHotels-Arena-Paris-France.jpg' },
  { nom: 'Johan Cruijff Arena',           ville: 'Amsterdam',              pays: 'Pays-Bas',   photo: 'https://dynamic-media-cdn.tripadvisor.com/media/photo-o/1b/6f/df/b7/caption.jpg?w=1200&h=-1&s=1' },
  { nom: 'Ziggo Dome',                    ville: 'Amsterdam',              pays: 'Pays-Bas',   photo: 'https://d1ize34iqy408p.cloudfront.net/images/ZiggoDome-2016_verkleind.width-2560.webp' },
  { nom: 'Domaine provincial De Schorre', ville: 'Boom',                   pays: 'Belgique',   photo: 'https://climbfinder.com/CDN/de-schorre-boom-upload-6192-1024x0.jpg' },
  { nom: 'Château de Chambord',           ville: 'Chambord',               pays: 'France',     photo: 'https://www.val-de-loire-41.com/wp-content/uploads/2023/10/chambord-septembre-2023-dnc-olivier-marchant-1-1600x900.jpg' },
  { nom: 'Groupama Stadium',              ville: 'Lyon',                   pays: 'France',     photo: 'https://media.lyon-france.com/1280x764/5042888/9983786.jpg' },
  { nom: 'Lotto Arena',                   ville: 'Anvers',                 pays: 'Belgique',   photo: 'https://antwerpconventionbureau.be/_next/image?url=https%3A%2F%2Fdonkeycomm-1.ams3.digitaloceanspaces.com%2Fantwerpconventionbureau-strapi%2FACB_lotto_arena_81a0493a3b.jpg&w=3840&q=75' },
  { nom: 'Zénith Paris La Villette',      ville: 'Paris',                  pays: 'France',     photo: 'https://www.businessprofilers.com/produit/images/960x480/le_zenith_paris_la_villette_12279/facade/le_zenith_paris_la_villette_facade_1.jpg' },
  { nom: "L'Orangerie de la Baie",        ville: 'Le Touquet Paris Plage', pays: 'France',     photo: 'https://phrnleng.rosselcdn.net/sites/default/files/dpistyles_v2/ena_16_9_extra_big/2023/07/07/node_179063/3318225/public/2023/07/07/B9734694185Z.1_20230707151440_000%2BG4SN2P0D3.1-0.jpg?itok=DotGFblu1688735689' },
  { nom: 'Hippodrome Paris Longchamp',    ville: 'Paris',                  pays: 'France',     photo: 'https://www.oteis.fr/wp-content/uploads/2016/03/photo_1.jpg' },
  { nom: "Citadelle d'Arras",             ville: 'Arras',                  pays: 'France',     photo: 'https://www.arrasville.fr/wp-content/uploads/2022/05/porte-quartier-turenne-citadelle-arras.jpg' },
  { nom: 'Ancienne Belgique',             ville: 'Bruxelles',              pays: 'Belgique',   photo: 'https://www.abconcerts.be/media/cache/ogimage/upload/media/default/ae/bac1fb6bb046353975be4e56a0737cf47b820a13.jpg' },
  { nom: 'Zénith de Lille',               ville: 'Lille',                  pays: 'France',     photo: 'https://upload.wikimedia.org/wikipedia/commons/1/18/Z%C3%A9nith_de_Lille_2014.JPG' },
  { nom: 'Château Dalle Dumont',          ville: 'Wervicq-Sud',            pays: 'France',     photo: 'https://www.wervicq-sud.com/wp-content/uploads/2021/02/chateau-et-parc-dalle-dumont.jpg' },
  { nom: 'Parvis St Christophe',          ville: 'Tourcoing',              pays: 'France',     photo: 'https://locations.filmfrance.net/sites/default/files/photos/ville-de-tourcoing-centre-127889/photo165696.jpg' },
  { nom: 'Site des Verreries',            ville: 'Fourmies',               pays: 'France',     photo: 'https://www.fourmies.fr/upload/sliders/34229_IMG-6915.jpg' },
  { nom: 'Euralille',                     ville: 'Lille',                  pays: 'France',     photo: 'https://lh3.googleusercontent.com/p/AF1QipPUcK3DazVCKygxCYxp8eZTwrl8qZIiKTQj9VAP=s680-w680-h510' },
  { nom: 'Sportpaleis Antwerpen',         ville: 'Anvers',                 pays: 'Belgique',   photo: 'https://img.standaard.be/E2OlX4lDJ6krgtPT8EtxkBydniU=/640x427/smart/https%3A%2F%2Fstatic.standaard.be%2FAssets%2FImages_Upload%2F2014%2F01%2F31%2Fea58a3b6-8a98-11e3-a965-d230c9a3b817_web_scale_0.0976563_0.0976563__.jpg' },
  { nom: 'Amnésia',                       ville: "Cap d'Agde",             pays: 'France',     photo: 'https://cdn-s-www.lejsl.com/images/222ae107-cb8e-497e-8fa6-9a09c961cd67/NW_raw/gregory-boudou-est-le-gerant-de-la-discotheque-l-amnesia-fondee-par-son-pere-andre-boudou-au-cap-d-agde-photo-afp-1522871600.jpg' },
  { nom: 'Décathlon Aréna – Stade Pierre Mauroy', ville: 'Lille',         pays: 'France',     photo: 'https://www.ostadium.com/galleries/stade-pierre-mauroy-illus.jpg' },
  { nom: 'La Défense Arena',              ville: 'Nanterre',               pays: 'France',     photo: 'https://thumbs.dreamstime.com/b/vue-ext%C3%A9rieure-sur-paris-la-d%C3%A9fense-arena-stade-et-salle-de-concert-nanterre-france-octobre-l-ar%C3%A8ne-le-est-un-une-polyvalents-293087450.jpg' },
  { nom: 'Phantom Club',                  ville: 'Paris',                  pays: 'France',     photo: 'https://i0.wp.com/paris-society.com/fr/uploads/sites/2/2024/04/02-Phantom-Club.jpg?ssl=1&w=2500&quality=85' },
  { nom: 'Hippodrome Croisé-Laroche',     ville: 'Marcq-en-Barœul',       pays: 'France',     photo: 'https://www.lilleevents.fr/wp-content/uploads/2020/10/PHOTOO-HIPPODROME3.png' },
  { nom: 'Antwerp Expo',                  ville: 'Anvers',                 pays: 'Belgique',   photo: 'https://cdn.eventplanner.fr/imgs/adv-92/15316-img-desktop-antwerp-expo@2x.jpg' },
  { nom: 'Parking Lacuzon',               ville: 'Valenciennes',           pays: 'France',     photo: 'https://www.citecongresvalenciennes.com/wp-content/uploads/2025/03/1.Valenciennes-place-darmes-hotel-de-ville-OTCVM-%C2%A9-claude.waeghemacker-HD-130.jpg' },
  { nom: 'Parc du Cinquantenaire',        ville: 'Bruxelles',              pays: 'Belgique',   photo: 'https://images.lecho.be/view?iid=Elvis:4wXTgmYQKaQA71oP6_FdTD&context=ONLINE&ratio=16/9&width=1280&u=1648705258000' },
];

async function getUid(argUid) {
  if (argUid) return argUid;
  const list = await admin.auth().listUsers(1);
  if (list.users.length === 0) throw new Error('Aucun utilisateur trouvé dans Firebase Auth.');
  return list.users[0].uid;
}

async function run() {
  const uid = await getUid(process.argv[2]);
  console.log(`Import vers users/${uid}/lieux`);

  const col = db.collection('users').doc(uid).collection('lieux');

  // Vérifier si la collection est déjà peuplée
  const existing = await col.limit(1).get();
  if (!existing.empty) {
    console.log('⚠️  La collection lieux contient déjà des données. Ajout sans doublon (basé sur nom+ville).');
    const snap = await col.get();
    const existingKeys = new Set(snap.docs.map(d => `${d.data().nom}|${d.data().ville}`));

    let added = 0;
    for (const lieu of lieux) {
      const key = `${lieu.nom}|${lieu.ville}`;
      if (existingKeys.has(key)) {
        console.log(`  · Skipped (déjà présent) : ${lieu.nom}`);
        continue;
      }
      await col.add({ ...lieu, adresse: '', type: '', capacite: 0, siteWeb: '' });
      console.log(`  + Ajouté : ${lieu.nom}, ${lieu.ville}`);
      added++;
    }
    console.log(`\n✅ ${added} lieu(x) ajouté(s).`);
  } else {
    const batch = db.batch();
    for (const lieu of lieux) {
      const ref = col.doc();
      batch.set(ref, { ...lieu, adresse: '', type: '', capacite: 0, siteWeb: '' });
    }
    await batch.commit();
    console.log(`✅ ${lieux.length} lieux importés.`);
  }

  process.exit(0);
}

run().catch(err => { console.error('❌', err.message); process.exit(1); });
