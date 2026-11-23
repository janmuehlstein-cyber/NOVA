const CACHE='nova-pulse-v2-1-0';
const ASSETS=['./','./index.html','./styles.css?v=2.1.0','./app.js?v=2.1.0','./manifest.webmanifest','./icon.svg'];
self.addEventListener('install',event=>event.waitUntil((async()=>{const cache=await caches.open(CACHE);await cache.addAll(ASSETS);await self.skipWaiting()})()));
self.addEventListener('activate',event=>event.waitUntil((async()=>{const keys=await caches.keys();await Promise.all(keys.filter(key=>key.startsWith('nova-pulse-')&&key!==CACHE).map(key=>caches.delete(key)));await self.clients.claim()})()));
self.addEventListener('fetch',event=>{
  if(event.request.method!=='GET')return;
  const url=new URL(event.request.url);
  if(url.origin!==self.location.origin)return;
  const shell=['.html','.js','.css'].some(ext=>url.pathname.endsWith(ext))||url.pathname.endsWith('/');
  if(shell){event.respondWith((async()=>{try{const fresh=await fetch(event.request,{cache:'no-store'});if(fresh.ok){const cache=await caches.open(CACHE);await cache.put(event.request,fresh.clone())}return fresh}catch{const cached=await caches.match(event.request);return cached||caches.match('./index.html')}})());return}
  event.respondWith(caches.match(event.request).then(cached=>cached||fetch(event.request).then(response=>{if(response.ok){const copy=response.clone();caches.open(CACHE).then(cache=>cache.put(event.request,copy))}return response})))
});
