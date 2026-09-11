import Foundation
import AppKit
import AVFoundation
import CoreVideo

let W = 1920, H = 1080, fps = 30, seconds = CommandLine.arguments.contains("--overview") ? 45 : (CommandLine.arguments.contains("--dashboard") ? 75 : 48)
let out = CommandLine.arguments.count > 1 ? CommandLine.arguments[1] : "booth-video/engineers-virtual-schema.mp4"
let navy = NSColor(calibratedRed:0.028,green:0.032,blue:0.075,alpha:1)
let panel = NSColor(calibratedRed:0.082,green:0.094,blue:0.16,alpha:1)
let teal = NSColor(calibratedRed:0.37,green:0.76,blue:0.23,alpha:1)
let gold = NSColor(calibratedRed:1,green:0.72,blue:0.27,alpha:1)
let muted = NSColor(calibratedRed:0.57,green:0.66,blue:0.77,alpha:1)
let officialLogo = NSImage(data: try! Data(contentsOf: URL(fileURLWithPath: "booth-video/assets/exasol-logo.svg")))!
let realDashboard = NSImage(contentsOf: URL(fileURLWithPath: "booth-video/assets/real-dashboard.png"))!
let realWoman = NSImage(contentsOf: URL(fileURLWithPath: "booth-video/assets/engineer-woman-real.png"))!
let realMan = NSImage(contentsOf: URL(fileURLWithPath: "booth-video/assets/engineer-man-real.png"))!
func brandLogo(_ x:Double,_ y:Double,_ height:Double=31) {
 let ratio=110.0/26.0
 let w=height*ratio
 let c=NSGraphicsContext.current!.cgContext
 c.saveGState();c.translateBy(x:x,y:2*y+height);c.scaleBy(x:1,y:-1)
 officialLogo.draw(in:NSRect(x:0,y:0,width:w,height:height),from:.zero,operation:.sourceOver,fraction:1)
 c.restoreGState()
}
func drawDashboardViewport(_ x:Double,_ y:Double,_ w:Double,_ h:Double,_ progress:Double) {
 // Preserve the dashboard's 16:9 ratio. The viewport pans vertically so the booth sees the full page.
 let fullH=w*1080.0/1920.0
 let pan=max(0,min(1,progress))
 let imageY=y-(fullH-h)*pan
 let c=NSGraphicsContext.current!.cgContext
 c.saveGState();c.addRect(CGRect(x:x,y:y,width:w,height:h));c.clip()
 c.translateBy(x:0,y:2*imageY+fullH);c.scaleBy(x:1,y:-1)
 realDashboard.draw(in:NSRect(x:x,y:imageY,width:w,height:fullH),from:.zero,operation:.sourceOver,fraction:1)
 c.restoreGState()
}
func brandStrip(_ label:String) {
 box(0,0,1920,24,teal,0)
 for i in 0..<40 { oval(Double(i)*52 + 18,7,3,3,NSColor.white.withAlphaComponent(0.16)) }
 text(label,760,5,14,navy,400,true)
}
func box(_ x:Double,_ y:Double,_ w:Double,_ h:Double,_ color:NSColor,_ r:Double=20) {
 let path=NSBezierPath(roundedRect:NSRect(x:x,y:y,width:w,height:h),xRadius:r,yRadius:r)
 if color == panel {
  NSGraphicsContext.saveGraphicsState();let shadow=NSShadow();shadow.shadowColor=NSColor.black.withAlphaComponent(0.22);shadow.shadowBlurRadius=22;shadow.shadowOffset=NSSize(width:0,height:8);shadow.set();color.setFill();path.fill();NSGraphicsContext.restoreGraphicsState()
  NSGradient(starting:panel.blended(withFraction:0.06,of:.white)!,ending:panel)!.draw(in:path,angle:90)
  NSColor.white.withAlphaComponent(0.10).setStroke();path.lineWidth=1;path.stroke()
 } else {color.setFill();path.fill()}
}
func oval(_ x:Double,_ y:Double,_ w:Double,_ h:Double,_ color:NSColor) { color.setFill(); NSBezierPath(ovalIn:NSRect(x:x,y:y,width:w,height:h)).fill() }
func text(_ s:String,_ x:Double,_ y:Double,_ size:Double,_ color:NSColor = .white,_ width:Double=1800,_ mono:Bool=false) {
 let p = NSMutableParagraphStyle(); p.lineSpacing = 9
 let font = NSFont(name:mono ? "Menlo-Regular" : (size>=50 ? "AvenirNext-Bold":"AvenirNext-DemiBold"),size:size) ?? NSFont.systemFont(ofSize:size,weight:.medium)
 (s as NSString).draw(in:NSRect(x:x,y:y,width:width,height:650),withAttributes:[.font:font,.foregroundColor:color,.paragraphStyle:p])
}
func line(_ x:Double,_ y:Double,_ xx:Double,_ yy:Double,_ c:NSColor,_ width:Double=3) { let p=NSBezierPath(); p.move(to:NSPoint(x:x,y:y));p.line(to:NSPoint(x:xx,y:yy));p.lineWidth=width;c.setStroke();p.stroke() }
func engineer(_ x:Double,_ y:Double,_ female:Bool,_ active:Bool,_ t:Double) {
 NSGraphicsContext.saveGraphicsState()
 let ctx=NSGraphicsContext.current!.cgContext
 ctx.translateBy(x:x,y:y+sin(t*2+(female ? 0:1))*2)
 let accent=female ? teal:gold
 let skin=female ? NSColor(calibratedRed:0.66,green:0.37,blue:0.26,alpha:1):NSColor(calibratedRed:0.87,green:0.62,blue:0.45,alpha:1)
 let hair=NSColor(calibratedRed:0.12,green:0.08,blue:0.105,alpha:1)
 let jacket=female ? NSColor(calibratedRed:0.30,green:0.28,blue:0.63,alpha:1):NSColor(calibratedRed:0.17,green:0.33,blue:0.48,alpha:1)
 oval(-120,220,240,26,NSColor.black.withAlphaComponent(0.25))
 oval(-114,-32,228,228,accent.withAlphaComponent(active ? 0.12:0.035))
 if female {oval(29,-33,59,67,hair);box(-64,-8,126,149,hair,49)}
 // Tailored jacket, tee, lapels and conference badge.
 box(-84,112,168,121,jacket,41)
 box(-29,112,58,112,NSColor(calibratedWhite:0.92,alpha:1),12)
 box(-18,84,36,47,skin,12)
 line(-38,119,-18,161,jacket.blended(withFraction:0.25,of:.white)!,9)
 line(38,119,18,161,jacket.blended(withFraction:0.25,of:.white)!,9)
 line(-15,133,0,176,accent,3);line(15,133,0,176,accent,3)
 box(-15,173,30,37,navy,5);box(-8,180,16,4,accent,2);box(-8,190,12,3,muted,1)
 // Ears, sculpted face and asymmetric hair.
 oval(-58,37,19,28,skin);oval(40,37,19,28,skin)
 oval(-47,-6,94,117,skin)
 oval(-43,18,23,66,NSColor.white.withAlphaComponent(0.055))
 let hp=NSBezierPath();hp.move(to:NSPoint(x:-49,y:41));hp.curve(to:NSPoint(x:-43,y:-13),controlPoint1:NSPoint(x:-64,y:2),controlPoint2:NSPoint(x:-53,y:-8));hp.curve(to:NSPoint(x:49,y:15),controlPoint1:NSPoint(x:19,y:-53),controlPoint2:NSPoint(x:62,y:-13));hp.curve(to:NSPoint(x:-28,y:14),controlPoint1:NSPoint(x:20,y:38),controlPoint2:NSPoint(x:-9,y:22));hp.line(to:NSPoint(x:-40,y:45));hp.close();hair.setFill();hp.fill()
 line(-24,37,-12,35,hair,3);line(13,35,25,37,hair,3)
 let blink=Int(t*30+(female ? 0:45))%133<4
 oval(-23,45,7,blink ? 2:8,navy);oval(17,45,7,blink ? 2:8,navy)
 line(2,49,5,63,skin.blended(withFraction:0.22,of:hair)!,2)
 if !female {
  for ex in [-37.0,8.0] {let p=NSBezierPath(roundedRect:NSRect(x:ex,y:36,width:31,height:26),xRadius:8,yRadius:8);navy.setStroke();p.lineWidth=3;p.stroke()};line(-6,45,8,45,navy,3)
  let beard=NSBezierPath();beard.move(to:NSPoint(x:-36,y:72));beard.curve(to:NSPoint(x:36,y:72),controlPoint1:NSPoint(x:-23,y:118),controlPoint2:NSPoint(x:29,y:113));beard.line(to:NSPoint(x:29,y:88));beard.curve(to:NSPoint(x:-29,y:88),controlPoint1:NSPoint(x:8,y:105),controlPoint2:NSPoint(x:-14,y:104));beard.close();hair.withAlphaComponent(0.85).setFill();beard.fill()
 } else {oval(-55,62,9,15,gold);oval(46,62,9,15,gold)}
 let mouth=NSBezierPath();mouth.move(to:NSPoint(x:-12,y:79));mouth.curve(to:NSPoint(x:14,y:78),controlPoint1:NSPoint(x:-3,y:89),controlPoint2:NSPoint(x:8,y:88));mouth.lineWidth=3;hair.setStroke();mouth.stroke()
 // One arm rests on a laptop; the other gestures while speaking.
 line(-72,149,-91,206,jacket,27);oval(-101,200,33,18,skin)
 let handY=active ? 150+sin(t*3)*9:205
 line(71,151,91,184,jacket,26);line(91,184,111,handY,jacket,22);oval(101,handY-13,24,30,skin)
 if active {line(110,handY-4,110,handY-26,skin,8)}
 box(-77,204,147,38,NSColor(calibratedRed:0.21,green:0.27,blue:0.37,alpha:1),7)
 line(-80,241,76,241,muted,4);text("{ }",-20,207,22,accent,70,true)
 NSGraphicsContext.restoreGraphicsState()
}
func legacyEngineer(_ x:Double,_ y:Double,_ female:Bool,_ active:Bool,_ t:Double) {
 let c = female ? teal : gold
 let bob = sin(t*2.7+(female ? 0:2))*4
 NSGraphicsContext.saveGraphicsState()
 NSGraphicsContext.current!.cgContext.translateBy(x:x,y:y+bob)
 oval(-114,215,228,35,NSColor.black.withAlphaComponent(0.25))
 if active { oval(-116,-30,232,232,c.withAlphaComponent(0.09)) }
 let skin = female ? NSColor(calibratedRed:0.70,green:0.40,blue:0.26,alpha:1) : NSColor(calibratedRed:0.91,green:0.65,blue:0.45,alpha:1)
 if female { box(-68,-9,136,152,NSColor(calibratedWhite:0.08,alpha:1),48) }
 box(-90,108,180,125,c,45)
 box(-18,81,36,45,skin,10)
 oval(-53,-13,106,118,skin)
 let hair=NSColor(calibratedRed:0.10,green:0.075,blue:0.095,alpha:1)
 oval(-57,-25,114,59,hair)
 if female { oval(-67,-20,43,113,hair) } else { box(-56,2,22,48,hair,8) }
 let blink = Int(t*30)%119 < 4
 for ex in [-22.0,22.0] { oval(ex-5,39,10,blink ? 2:9,navy) }
 if !female { let p=NSBezierPath(roundedRect:NSRect(x:-43,y:27,width:37,height:31),xRadius:9,yRadius:9); navy.setStroke();p.lineWidth=4;p.stroke(); let q=NSBezierPath(roundedRect:NSRect(x:6,y:27,width:37,height:31),xRadius:9,yRadius:9);q.lineWidth=4;q.stroke();line(-6,40,6,40,navy,4) }
 let mouth=NSBezierPath(); mouth.move(to:NSPoint(x:-13,y:73));mouth.curve(to:NSPoint(x:13,y:73),controlPoint1:NSPoint(x:-5,y:82),controlPoint2:NSPoint(x:8,y:82));mouth.lineWidth=3;navy.setStroke();mouth.stroke()
 line(-12,128,0,152,navy.withAlphaComponent(0.4),3);line(12,128,0,152,navy.withAlphaComponent(0.4),3)
 box(-104,174,208,70,NSColor(calibratedRed:0.13,green:0.19,blue:0.27,alpha:1),10)
 text("</>",-26,189,28,c,100,true)
 NSGraphicsContext.restoreGraphicsState()
}
let headings = ["Two engineers. One data question.","Different databases. Same question.","Meet Virtual Schemas.","Write SQL across both worlds.","One result. A clearer picture.","Bring your data question."]
let questions = ["Can we join MongoDB data\nwith orders in Exasol?","Do we need another\ndata-copying pipeline?","How does MongoDB\nbecome queryable?","Can I use the SQL\nI already know?","So, revenue by city\nand loyalty tier?","Can we see this\nworking live?"]
let answers = ["Yes. Let’s connect the dots.","Query the external data\nthrough a Virtual Schema.","The adapter exposes it\nas virtual tables in Exasol.","Yes. Join virtual tables\nwith your Exasol tables.","Exactly. One query brings\nthe two sources together.","Let’s run a query.\nTalk to us at the booth."]
let sql = "SELECT loc.\"city\"            AS MONGO_CITY,\n       l.\"tier\"              AS MONGO_TIER,\n       ROUND(SUM(o.REVENUE)) AS EXASOL_REVENUE\nFROM   RETAIL.ORDERS o\nJOIN   MONGO_RETAIL.\"CUSTOMERS\" c\n       ON c.\"customer_id\" = o.CUSTOMER_ID\nJOIN   MONGO_RETAIL.\"CUSTOMERS_location\" loc\n       ON loc.\"_id\" = c.\"location|object\"\nJOIN   MONGO_RETAIL.\"CUSTOMERS_loyalty\" l\n       ON l.\"_id\" = c.\"loyalty|object\"\nGROUP BY 1, 2 ORDER BY 3 DESC LIMIT 5;"
func ease(_ v:Double)->Double {let p=max(0,min(1,v));return 1-pow(1-p,3)}
func person(_ x:Double,_ y:Double,_ scale:Double,_ female:Bool,_ active:Bool,_ t:Double) {
 NSGraphicsContext.saveGraphicsState()
 let c=NSGraphicsContext.current!.cgContext
 let photoScale=scale*0.72
 c.translateBy(x:x,y:y+110*scale+sin(t*2.0)*2);c.scaleBy(x:photoScale,y:photoScale)
 if active {oval(-370,-450,740,740,teal.withAlphaComponent(0.10))}
 let image=female ? realWoman:realMan
 let w=716.0,h=716.0
 c.saveGState();c.translateBy(x:0,y:2*(-358)+h);c.scaleBy(x:1,y:-1)
 image.draw(in:NSRect(x:-358,y:-358,width:w,height:h),from:.zero,operation:.sourceOver,fraction:1)
 c.restoreGState()
 NSGraphicsContext.restoreGraphicsState()
}
func database(_ x:Double,_ y:Double,_ title:String,_ detail:String,_ c:NSColor) {
 box(x,y,450,210,panel,26);box(x,y,6,210,c,3)
 text(title,x+32,y+24,45,c,400);text(detail,x+32,y+99,27,.white,395)
}
func draw(_ t:Double) {
 if CommandLine.arguments.contains("--overview") {drawOverview(t);return}
 if CommandLine.arguments.contains("--dashboard") {drawDashboard(t);return}
 if CommandLine.arguments.contains("--udf") {drawUDF(t);return}
 let ctx=NSGraphicsContext.current!.cgContext
 NSGradient(colors:[navy,NSColor(calibratedRed:0.085,green:0.07,blue:0.17,alpha:1),navy])!.draw(in:NSRect(x:0,y:0,width:1920,height:1080),angle:20)
 brandStrip("EXASOL  /  ANALYTICS DATABASE")
 for i in 0..<16 {let p=Double(i);line(1000+p*105+sin(t*0.2)*25,0,300+p*105,1080,teal.withAlphaComponent(0.025),1)}
 brandLogo(80,42,31)
 text("THE SQL CHALLENGE",1480,49,23,muted,400)
 line(80,99,1840,99,muted.withAlphaComponent(0.19),1)
 let start:Double=t<4 ? 0:t<9 ? 4:t<13 ? 9:t<17 ? 13:t<33 ? 17:t<43 ? 33:43
 let u=t-start
 let rise=55*(1-ease(u/0.6))
 if t<4 {
  text("TWO DATABASES.",100,200+rise,119,.white,1700)
  if u>0.45 {text("ONE SQL QUERY?",100,353+50*(1-ease((u-0.45)/0.6)),126,teal,1750)}
  let s=ease((u-0.9)/0.7)
  database(100-650*(1-s),645,"MongoDB","Customer profiles",teal)
  database(1370+650*(1-s),645,"Exasol","Orders + revenue",gold)
  text("+",905,671,87,.white,150)
  text("Watch the JOIN happen.",101,923,34,muted,1600)
 } else if t<9 {
  text("“My data lives in two places.”",900,151+rise,56,.white,1020)
  person(330,448,1.9,true,true,t)
  database(965,327,"MongoDB","City + loyalty tier",teal)
  database(965,600,"Exasol","Order revenue",gold)
  text("How do I JOIN it?",965,879,62,teal,830)
 } else if t<13 {
  person(1480,407,2.25,false,true,t)
  text("WATCH",95,221+rise,153,.white,1150)
  text("THIS.",95,395+rise,177,teal,1100)
  text("Your SQL. Across both sources.",104,731,43,.white,1110)
  text("Powered by Exasol Virtual Schemas",104,817,29,muted,1110)
 } else if t<17 {
  text("CONNECT. THEN JOIN.",95,173+rise,92,.white,1770)
  database(95,451,"MongoDB","External customer data",teal)
  database(1375,451,"Exasol","Local orders table",gold)
  line(557,556,1363,556,teal.withAlphaComponent(0.3),5)
  for i in 0..<10 {let p=(u*0.43+Double(i)/10).truncatingRemainder(dividingBy:1);oval(557+806*p,550,12,12,i%2==0 ? teal:gold)}
  box(684,488,552,140,navy,22);text("VIRTUAL SCHEMA",728,531,41,teal,500)
  text("MongoDB data becomes queryable as virtual tables.",180,787,43,.white,1650)
  text("Now let the SQL do the talking.",180,893,34,muted,1600)
 } else if t<33 {
  // Large, complete SQL remains on screen while attention moves JOIN by JOIN.
  let stage=min(4,Int(u/3.2))
  let labels=["START WITH ORDERS.","JOIN THE CUSTOMERS.","ADD THEIR CITY.","ADD LOYALTY TIER.","SUM. GROUP. RANK."]
  text(labels[stage],80,132,66,.white,1780)
  box(80,241,1375,708,panel,24)
  text("SQL",109,258,20,teal,120);text("MONGODB + EXASOL",1062,258,20,muted,350)
  let lines=sql.components(separatedBy:"\n")
  let focus:[[Int]]=[[3],[4,5],[6,7],[8,9],[0,1,2,10]]
  for (i,s) in lines.enumerated() {
   let y=312+Double(i)*54
   let selected=focus[stage].contains(i)
   if selected {box(101,y-3,1329,49,(stage==0 ? gold:teal).withAlphaComponent(0.12),7);box(101,y-3,4,49,stage==0 ? gold:teal,2)}
   text(String(format:"%02d",i+1),117,y+3,22,muted,55,true)
   text(s,173,y,31,selected ? .white:muted,1250,true)
  }
  let names=["ORDERS","CUSTOMERS","LOCATION","LOYALTY","RESULT"]
  let subtitles=["Exasol revenue","MongoDB profiles","MongoDB city","MongoDB tier","Top 5 groups"]
  for i in 0..<5 {
   let y=264+Double(i)*134
   let lit=i<=stage
   if i>0 {line(1502,y-34,1502,y-5,lit ? teal:panel,3)}
   oval(1492,y+14,20,20,lit ? (i==0 ? gold:teal):panel)
   text(names[i],1532,y,29,lit ? .white:muted,315)
   text(subtitles[i],1532,y+48,22,lit ? (i==0 ? gold:teal):muted,320)
  }
  text("FULL QUERY  /  Follow each highlighted JOIN",83,982,25,muted,1550)
 } else if t<43 {
  text("TWO SOURCES. ONE RESULT.",80,137+rise,75,.white,1780)
  box(80,283,1030,550,panel,22)
  text("THE COMPLETE SQL",106,299,19,muted,990)
  text(sql,107,346,27,.white,987,true)
  box(1130,283,710,550,panel,22)
  box(1130,243,240,33,teal,7);text("FROM MONGODB",1145,246,19,navy,235)
  box(1610,243,230,33,gold,7);text("FROM EXASOL",1630,246,19,navy,230)
  text("MONGO_CITY",1151,309,20,teal,230,true);text("MONGO_TIER",1380,309,20,teal,205,true);text("EXASOL_REVENUE",1600,309,20,gold,240,true)
  let rows=[("Hyderabad","Silver","1,086,700"),("Ahmedabad","Gold","1,065,615"),("Hyderabad","Gold","1,029,700"),("Kochi","Gold","1,011,870"),("Kochi","Silver","960,570")]
  for (i,r) in rows.enumerated() {let y=388+Double(i)*85;line(1148,y-20,1822,y-20,muted.withAlphaComponent(0.16),1)
   if u>Double(i)*0.32+0.35 {let dx=28*(1-ease((u-Double(i)*0.32-0.35)/0.5));text(r.0,1151+dx,y,26,teal,240,true);text(r.1,1380+dx,y,26,teal,200,true);text(r.2,1658+dx,y,26,gold,180,true)}
  }
  text("Customer context × order revenue",80,882,50,teal,1600)
  text("VIRTUAL SCHEMAS  /  Example query and results",83,968,25,muted,1600)
 } else {
  text("YOUR DATA.",95,174+rise,119,.white,1700)
  text("YOUR QUESTION.",95,323+rise,119,teal,1720)
  text("LET’S RUN THE SQL.",95,517+rise,90,.white,1700)
  box(100,727,1260,120,teal,16);text("SEE IT LIVE AT THE EXASOL BOOTH",135,759,44,navy,1220)
  text("MongoDB + Exasol  /  Virtual Schemas",103,919,32,muted,1360)
  person(1630,729,0.94,false,true,t)
 }
 // Subtle progress rail; brief non-flashing wipe between compositions.
 box(80,1036,1760,3,muted.withAlphaComponent(0.15),1);box(80,1036,1760*t/48,3,teal,1)
 if u<0.28 && t>0.1 {let p=ease(u/0.28);box(1920*p,110,1920*(1-p),900,navy,0)}
 if t>47.6 {box(0,0,1920,1080,navy.withAlphaComponent((t-47.6)/0.4),0)}
 _ = ctx
}
let udfSQL = "SELECT o.\"order_id\"          AS ORDER_ID,\n       o.\"sub_category\"      AS SUB_CATEGORY,\n       ROUND(o.\"discount\",2) AS DISCOUNT,\n       ROUND(o.\"profit\",0)   AS ACTUAL_PROFIT,\n       ROUND(ML.LOSS_SCORE(o.\"discount\", o.\"quantity\", o.\"sales\",\n             o.\"shipping_cost\", o.\"category\", o.\"sub_category\",\n             o.\"market\", o.\"region\", o.\"ship_mode\",\n             o.\"segment\"), 4) AS LOSS_RISK\nFROM MONGO_SUPERSTORE.\"ORDERS\" o\nWHERE o.\"category\" = 'Furniture' AND o.\"market\" = 'EU'\nORDER BY LOSS_RISK DESC LIMIT 5;"
func drawUDF(_ t:Double) {
 NSGradient(colors:[navy,NSColor(calibratedRed:0.11,green:0.055,blue:0.19,alpha:1),navy])!.draw(in:NSRect(x:0,y:0,width:1920,height:1080),angle:25)
 brandStrip("EXASOL  /  PYTHON + SQL + AI")
 for i in 0..<16 {line(1000+Double(i)*105+sin(t*0.2)*25,0,300+Double(i)*105,1080,teal.withAlphaComponent(0.025),1)}
 brandLogo(80,42,31);text("THE PYTHON UDF CHALLENGE",1310,49,23,muted,540)
 line(80,99,1840,99,muted.withAlphaComponent(0.19),1)
 let start:Double=t<4 ? 0:t<8 ? 4:t<14 ? 8:t<22 ? 14:t<36 ? 22:t<43 ? 36:43
 let u=t-start, rise=45*(1-ease((t-start)/0.55))
 if t<4 {
  text("YOUR PYTHON MODEL.",95,215+rise,106,.white,1740)
  if u>0.5 {text("CALLED FROM SQL?",95,368+40*(1-ease((u-0.5)/0.6)),115,teal,1740)}
  let p=ease((u-0.8)/0.65)
  database(100-650*(1-p),665,"scikit-learn","A trained loss-risk model",teal)
  database(1370+650*(1-p),665,"Exasol","Predictions inside SQL",gold)
  text("→",889,674,101,.white,200)
  text("Watch a model become a SQL function.",100,955,32,muted,1700)
 } else if t<8 {
  person(340,425,2.0,true,true,t)
  text("“I trained a model.”",930,241+rise,67,.white,900)
  text("“Can SQL use it?”",930,404+rise,74,teal,900)
  text("Predict which order lines\nare likely to lose money.",935,676,40,.white,880)
 } else if t<14 {
  text("TRAIN IT. BRING IT. CALL IT.",80,157+rise,79,.white,1770)
  let names=["scikit-learn","loss_model.pkl","BucketFS","Python UDF"]
  let desc=["Train in Docker","Save the pipeline","Store the model","Predict in Exasol"]
  for i in 0..<4 {let x=80+Double(i)*450;let on=u>Double(i)*0.65;box(x,432,410,220,panel,20);text(String(format:"%02d",i+1),x+26,449,24,on ? teal:muted,100);text(names[i],x+26,492,35,on ? .white:muted,375);text(desc[i],x+26,563,25,on ? teal:muted,370)
   if i<3 {line(x+416,542,x+444,542,teal,3);let v=(u*0.8+Double(i)*0.2).truncatingRemainder(dividingBy:1);oval(x+416+28*v,537,9,9,gold)}
  }
  text("Train outside Exasol. Run prediction inside Exasol.",90,762,45,.white,1730)
  text("scikit-learn pipeline: one-hot encoding → gradient boosting",93,866,29,muted,1700)
 } else if t<22 {
  text("THE MODEL LIVES HERE.",80,149+rise,82,.white,1760)
  box(80,286,1760,133,panel,20)
  text("BUCKETFS  /  READABLE BY THE UDF",110,305,21,teal,1650)
  text("/buckets/bfsdefault/ml/loss_model.pkl",110,351,41,.white,1670,true)
  box(80,452,1260,458,panel,22)
  text("ML.LOSS_SCORE  /  SOURCE EXCERPTS",112,478,22,teal,1200)
  let snippets=["import joblib","import pandas as pd","","MODEL = joblib.load(","    '/buckets/bfsdefault/ml/loss_model.pkl')","","# Inside run(ctx), after feature preparation:","X = pd.DataFrame([row])[NUM + CAT]","return float(MODEL.predict_proba(X)[0, 1])"]
  for (i,s) in snippets.enumerated() {text(s,112,534+Double(i)*39,27,i==3 || i==4 || i==8 ? .white:muted,1195,true)}
  text("LOAD ONCE",1400,475,39,teal,440)
  text("Per UDF process",1400,539,28,.white,440)
  text("RETURN A SCORE",1400,669,34,gold,440)
  text("Loss probability",1400,731,28,.white,440)
  text("Python behind the function. SQL at the point of use.",84,959,33,.white,1740)
 } else if t<36 {
  let phase=min(3,Int(u/3.5))
  let titles=["CALL THE MODEL IN SQL.","PASS THE ORDER FEATURES.","PREDICTION + ACTUAL PROFIT.","RANK THE RISKIEST LINES."]
  text(titles[phase],80,139,67,.white,1780)
  box(80,253,1760,665,panel,22)
  text("EXACT QUERY  /  ML.LOSS_SCORE",110,273,22,teal,1100)
  let focus=[[4,5,6,7],[4,5,6,7],[3,7],[8,9,10]]
  for (i,s) in udfSQL.components(separatedBy:"\n").enumerated() {
   let y=330+Double(i)*49, active=focus[phase].contains(i)
   if active {box(103,y-3,1707,46,teal.withAlphaComponent(0.12),6);box(103,y-3,4,46,teal,2)}
   text(String(format:"%02d",i+1),120,y+3,23,muted,55,true)
   text(s,177,y,30,active ? .white:muted,1620,true)
  }
  let notes=["A Python UDF in an ordinary SELECT.","Ten input features. Profit is not a model input.","LOSS_RISK is predicted. ACTUAL_PROFIT is observed.","Furniture orders in the EU → highest predicted loss risk first."]
  text(notes[phase],85,959,31,phase==2 ? gold:teal,1760)
 } else if t<43 {
  text("SCORE IN BATCHES. QUERY A VIEW.",80,146+rise,65,.white,1780)
  box(80,287,830,137,panel,20);text("ML.PREDICT_LOSS",108,307,39,teal,780);text("SET UDF  /  scores a DataFrame",108,365,27,.white,780)
  text("→",934,312,61,gold,110)
  box(1050,287,790,137,panel,20);text("ML.SCORED_LINES",1078,307,39,gold,740);text("A view your SQL tools can query",1078,365,27,.white,740)
  box(80,462,1760,400,panel,22)
  text("EXACT AGGREGATION QUERY FROM THE DEMO",112,484,22,teal,1650)
  let q="SELECT MARKET, COUNT(*) AS LINES_N,\n       ROUND(100*AVG(CASE WHEN LOSS_RISK >= 0.9\n         THEN 1 ELSE 0 END),1) AS PCT_FLAGGED,\n       ROUND(SUM(CASE WHEN LOSS_RISK >= 0.9\n         THEN PROFIT ELSE 0 END),0) AS FLAGGED_PROFIT\nFROM ML.SCORED_LINES\nGROUP BY 1 ORDER BY PCT_FLAGGED DESC;"
  text(q,112,541,31,.white,1670,true)
  text("SQL → dashboards → AI through MCP",85,921,44,teal,1750)
  text("Same model. A scalar call for clarity; a SET call for batched scoring.",88,993,25,muted,1740)
 } else {
  text("YOUR MODEL.",95,174+rise,116,.white,1730)
  text("YOUR SQL.",95,323+rise,116,teal,1730)
  text("LET’S RUN A PREDICTION.",95,520+rise,76,.white,1730)
  box(100,727,1260,120,teal,16);text("SEE PYTHON UDFs AT THE EXASOL BOOTH",130,767,37,navy,1220)
  text("scikit-learn  /  BucketFS  /  SQL",103,919,32,muted,1360)
  person(1630,729,0.94,false,true,t)
 }
 box(80,1043,1760,3,muted.withAlphaComponent(0.15),1);box(80,1043,1760*t/48,3,teal,1)
 if u<0.28 && t>0.1 {let p=ease(u/0.28);box(1920*p,110,1920*(1-p),900,navy,0)}
 if t>47.6 {box(0,0,1920,1080,navy.withAlphaComponent((t-47.6)/0.4),0)}
}
func personaDashboard(_ x:Double,_ y:Double,_ w:Double,_ h:Double,_ persona:Int,_ t:Double) {
 let names=["FINANCE","SALES","PRODUCT","DATA SCIENCE"]
 let titles=["Retail Finance","Retail Sales","Product Performance","Customer Intelligence"]
 let subtitles=["Realised revenue, not booked revenue","Stores, channels and order volume","Category and product-line movement","Customer features and loyalty tiers"]
 let kpi:[[String]]=[
  ["NET REVENUE|₹9.8M","LOST REVENUE|₹4.9M","GROSS MARGIN|45.0%","ROWS|2,500"],
  ["ORDERS|2,500","AVG ORDER|₹3.9K","TOP STORE|Delhi Select","CHANNELS|3"],
  ["PRODUCTS|16","TOP CATEGORY|Furniture","UNITS|6.2K","RETURN RATE|14.3%"],
  ["CUSTOMERS|250","LOYALTY TIERS|3","AVG VALUE|₹9.8K","CITY GROUPS|6"]]
 let active=persona % names.count
 let questions=["Why is realised revenue lower?","Which store leads this quarter?","Which category is moving fastest?","Which customers need attention?"]
 box(x,y,w,h,panel,18)
 text(titles[active],x+28,y+22,34,.white,500)
 text(subtitles[active],x+28,y+70,20,muted,850)
 for i in 0..<names.count {
  let tx=x+w-680+Double(i)*160
  let selected=i==active
  text(names[i],tx,y+29,17,selected ? teal:muted,145, true)
  if selected {box(tx,y+59,112,4,teal,2)}
 }
 for i in 0..<4 {
  let cardW=(w-74)/4
  let cx=x+18+Double(i)*(cardW+12)
  box(cx,y+112,cardW,88,NSColor(calibratedWhite:0.98,alpha:0.96),12)
  let pair=kpi[active][i].split(separator:"|",maxSplits:1).map(String.init)
  text(pair[0],cx+15,y+127,14,NSColor(calibratedRed:0.18,green:0.24,blue:0.34,alpha:1),cardW-25,true)
  text(pair.count>1 ? pair[1] : "",cx+15,y+151,24,navy,cardW-25,true)
 }
 box(x+18,y+220,w*0.56,h-242,NSColor(calibratedWhite:0.98,alpha:0.96),12)
 text("INSIGHTS  /  READ THE QUERY, THEN ACT",x+38,y+239,16,navy,850,true)
 let insights=["Realised revenue is the decision metric.","Delhi Select leads on realised revenue.","Average line value is uneven across stores."]
 for i in 0..<3 {
  let iy=y+274+Double(i)*76
  oval(x+40,iy+5,12,12,i==1 ? gold:teal)
  text(insights[(i+active)%insights.count],x+64,iy,18,navy,880)
  text(i==0 ? "ACTION  Compare the drivers, not just the totals." : "ACTION  Use the shared view to investigate.",x+64,iy+28,14,NSColor(calibratedWhite:0.28,alpha:1),880,true)
  line(x+38,iy+58,x+w*0.56-22,iy+58,NSColor(calibratedWhite:0.65,alpha:0.5),1)
 }
 let chartX=x+w*0.60+24, chartY=y+220, chartW=w*0.40-46, chartH=h-242
 box(chartX,chartY,chartW,chartH,NSColor(calibratedWhite:0.98,alpha:0.96),12)
 text(active==0 ? "NET REVENUE BY PERIOD" : "ACTIVITY BY PERIOD",chartX+18,chartY+20,16,navy,chartW-34,true)
 for j in 0..<6 {
  let barH=70+Double((j+active*2)%5)*30 + 18*sin(t*2.0+Double(j))
  let bx=chartX+24+Double(j)*(chartW-62)/6
  box(bx,chartY+68,36,barH, j==4 ? gold:teal,7)
  text("Q\(j+1)",bx+5,chartY+47,12,muted,28,true)
 }
 box(x+38,y+h-112,w*0.56-76,58,NSColor(calibratedRed:0.08,green:0.12,blue:0.19,alpha:1),10)
 text("ASK EXASOL",x+56,y+h-101,14,teal,155,true)
 text(questions[active],x+220,y+h-101,17,.white,420)
 oval(x+w*0.56-74,y+h-96,18,18,teal)
 text("↗",x+w*0.56-71,y+h-94,15,navy,18,true)
}

func drawDashboard(_ t:Double) {
 NSGradient(colors:[navy,NSColor(calibratedRed:0.035,green:0.105,blue:0.16,alpha:1),navy])!.draw(in:NSRect(x:0,y:0,width:1920,height:1080),angle:25)
 brandStrip("EXASOL  /  ONE VIEW FOR EVERY TEAM")
 for i in 0..<16 {line(1000+Double(i)*105+sin(t*0.2)*25,0,300+Double(i)*105,1080,teal.withAlphaComponent(0.025),1)}
 brandLogo(80,42,31);text("THE DASHBOARD CHALLENGE",1300,49,23,muted,550)
 line(80,99,1840,99,muted.withAlphaComponent(0.19),1)
 let start:Double=t<4 ? 0:t<8 ? 4:t<14 ? 8:t<24 ? 14:t<36 ? 24:t<43 ? 36:43
 let u=t-start, rise=45*(1-ease((t-start)/0.55))
 if t<4 {
  text("ONE SQL VIEW.",95,215+rise,124,.white,1740)
  if u>0.5 {text("SIX DASHBOARDS?",95,381+40*(1-ease((u-0.5)/0.6)),117,teal,1740)}
  text("Finance. Sales. Product. Data science. Inventory. Delivery.",102,663,39,.white,1710)
  box(100,794,1710,105,panel,18);text("Exasol + MongoDB  →  dash-server  →  your browser",132,820,41,gold,1650)
 } else if t<8 {
  person(335,414,2.05,true,true,t)
  person(1640,730,0.78,false,true,t)
  text("“The JOIN works.”",960,220+rise,70,.white,900)
  text("“Can my team\nuse it?”",960,380+rise,76,teal,900)
  text("Make the query a dashboard.",965,762,40,.white,850)
 } else if t<14 {
  text("FROM SQL TO SCREEN.",80,158+rise,89,.white,1770)
  let names=["MongoDB","Exasol view","dash-server","Browser"]
  let details=["Customer context","Orders + customers","Hosts the Dash apps","Six audience views"]
  for i in 0..<4 {let x=80+Double(i)*450;let on=u>Double(i)*0.65;box(x,409,410,220,panel,20);text(String(format:"%02d",i+1),x+26,427,24,on ? teal:muted,100);text(names[i],x+26,476,36,on ? .white:muted,375);text(details[i],x+26,554,24,on ? teal:muted,370)
   if i<3 {line(x+416,520,x+444,520,teal,3);let v=(u*0.8+Double(i)*0.2).truncatingRemainder(dividingBy:1);oval(x+416+28*v,515,9,9,gold)}
  }
  text("RETAIL.ORDERS_ENRICHED",85,730,57,teal,1720,true)
  text("A view over the federated JOIN. Nothing materialised.",88,847,40,.white,1720)
 } else if t<24 {
  let first=u<5
  text(first ? "THE SQL BEHIND THE SCREEN." : "ONE QUERY. THE CORE METRICS.",80,145,67,.white,1780)
  box(80,263,1760,659,panel,22)
  text(first ? "ORDERS_ENRICHED.SQL  /  JOIN EXCERPT" : "06_DASHBOARD.SH  /  COMPLETE SUMMARY QUERY",110,284,23,teal,1630)
  let query=first ? "FROM RETAIL.ORDERS o\nJOIN MONGO_RETAIL.\"CUSTOMERS\" c\n  ON c.\"customer_id\" = o.CUSTOMER_ID\nJOIN MONGO_RETAIL.\"CUSTOMERS_location\" lo\n  ON lo.\"_id\" = c.\"location|object\"\nJOIN MONGO_RETAIL.\"CUSTOMERS_loyalty\" ly\n  ON ly.\"_id\" = c.\"loyalty|object\"\nJOIN MONGO_RETAIL.\"CUSTOMERS_preferences\" p\n  ON p.\"_id\" = c.\"preferences|object\";" : "SELECT COUNT(*) AS ROWS_JOINED,\n       COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMERS,\n       ROUND(SUM(REVENUE),0) AS BOOKED,\n       ROUND(SUM(NET_REVENUE),0) AS REALISED,\n       ROUND(SUM(LOST_REVENUE),0) AS LOST\nFROM RETAIL.ORDERS_ENRICHED;"
  for (i,s) in query.components(separatedBy:"\n").enumerated() {let y=356+Double(i)*(first ? 56:75);let focus=first ? (i==min(8,1+Int(u)*2) || i==min(8,2+Int(u)*2)) : i==min(5,Int(u-5));if focus {box(102,y-3,1708,52,teal.withAlphaComponent(0.12),7)};text(s,123,y,first ? 33:38,focus ? teal:.white,1660,true)}
  text(first ? "Exasol facts + MongoDB customer documents" : "Booked ≠ realised. Cancelled and returned revenue is lost.",85,965,34,gold,1740)
 } else if t<36 {
  text("NOW EVERY TEAM CAN SEE IT.",80,131+rise,68,.white,1770)
  let persona=min(3,Int(u/3.0))
  personaDashboard(80,236,1760,710,persona,t)
  box(108,965,1190,46,navy.withAlphaComponent(0.94),8)
  text("REAL DASHBOARD LOGIC FROM ARCHIVE 2  /  animated persona views",130,976,22,.white,1160)
  text("FINANCE · SALES · PRODUCT · DATA SCIENCE",1290,976,18,muted,510,true)
 } else if t<43 {
  text("SAME VIEW. SIX PERSPECTIVES.",80,145+rise,68,.white,1780)
  let names=["FINANCE","SALES","PRODUCT","DATA SCIENCE","INVENTORY","DELIVERY"]
  let desc=["Booked vs realised vs lost","Stores + channels","Categories + product lines","Customer-feature controls","Reorder pressure","Pipeline + delivery tiers"]
  let ids=["retail-finance","retail-sales","retail-product","retail-datascience","retail-inventory","retail-delivery"]
  for i in 0..<6 {let x=80+Double(i%3)*600,y=291+Double(i/3)*259;let p=ease((u-Double(i)*0.17)/0.6);box(x,y+20*(1-p),560,222,panel,20);text(names[i],x+27,y+31,33,i==Int(u/1.1)%6 ? gold:teal,510);text(desc[i],x+27,y+96,25,.white,510);text(ids[i],x+27,y+163,21,muted,510,true)}
  text("Check contracts → deploy → verify the browser page",86,894,40,.white,1740)
  text("dryrun.py                 ship.sh                 preflight.py",89,981,26,muted,1740,true)
 } else if t<46 {
  text("WHAT ELSE DOES EXASOL DO?",90,235+rise,82,.white,1740)
  text("LET’S OPEN THE TOOLBOX.",90,380+rise,83,teal,1740)
  text("Analytics, AI, lakehouse acceleration — one governed engine.",95,620,37,muted,1650)
  for i in 0..<6 {let p=ease((u-Double(i)*0.12)/0.45);box(155+Double(i)*270,770+35*(1-p),205,8, i<3 ? teal:gold,4)}
 } else if t<61 {
  let fu=t-46
  let fNames=["Virtual Schemas","Python UDFs","Dashboards","Lakehouse Turbo","Text-to-SQL","AI Lab + GPU"]
  let fDesc=["Query external data with SQL","Run ML where data lives","Turn queries into shared action","Accelerate Iceberg + Delta","Natural language → governed SQL","Build, train and deploy models"]
  let fUse=["Federation without copying","Python, scikit-learn, UDF logic","Finance, sales, product teams","Faster lakehouse analytics","Ask questions, inspect SQL","Jupyter, Text AI, GPU workflows"]
  let idx=min(5,Int(fu/2.5)); let local=fu-Double(idx)*2.5; let p=ease(local/0.65)
  text("EXASOL TOOLBOX",90,132,42,muted,520,true)
  text(fNames[idx],90,226,96,teal,900)
  text(fDesc[idx],95,370,50,.white,1000)
  box(95,520,900,190,panel,22)
  text("WHERE IT HELPS",130,552,22,gold,800,true)
  text(fUse[idx],130,612,38,.white,800)
  text("One SQL surface. One governed path to insight.",130,670,27,muted,800)
  for i in 0..<6 {let on=i==idx;let rowY=220+Double(i)*108;box(1110,rowY,650,70,on ? teal:panel,14);text(String(format:"%02d",i+1),1140,rowY+22,20,on ? navy:muted,60,true);text(fNames[i],1210,rowY+21,27,on ? navy:muted,500);if on {box(1210,rowY+66,440,4,gold,2)}}
 } else if t<67 {
  text("WAIT…",90,190+rise,105,.white,800)
  text("HOW MUCH DOES THIS COST?",90,332+rise,71,teal,1250)
  text("DO I NEED A CLOUD ACCOUNT?",90,490+rise,55,.white,1320)
  person(1550,555,1.55,false,true,t)
  text("Seriously?",110,760,49,gold,600,true)
  text("There must be a catch.",110,833,34,muted,600)
 } else {
  text("NO CLOUD ACCOUNT REQUIRED.",90,145+rise,76,teal,1400)
  text("START FREE. RUN IT LOCALLY.",90,270+rise,70,.white,1400)
  box(90,415,850,350,panel,22)
  text("EXASOL PERSONAL LOCAL",130,451,24,teal,760,true)
  box(130,505,750,74,NSColor(calibratedRed:0.12,green:0.16,blue:0.24,alpha:1),13)
  text("$ curl …starterkit/main/install.sh | sh",158,530,22,.white,690,true)
  text("Single node · your laptop · your data",130,638,32,.white,760)
  text("Install → connect MCP → ask your first question",130,700,25,muted,760)
  text("FREE FOR PERSONAL USE",1050,440,46,gold,700,true)
  text("No replatforming.\nNo waiting for a cloud account.",1050,545,46,.white,720)
  text("Bring your SQL, CSVs and AI client.",1050,710,28,muted,720)
  text("SEE YOU AT THE EXASOL BOOTH",90,918,30,gold,980,true)
 }
 box(80,1043,1760,3,muted.withAlphaComponent(0.15),1);box(80,1043,1760*t/75,3,teal,1)
 if u<0.28 && t>0.1 {let p=ease(u/0.28);box(1920*p,110,1920*(1-p),900,navy,0)}
 if t>74.6 {box(0,0,1920,1080,navy.withAlphaComponent((t-74.6)/0.4),0)}
}
func flow(_ x:Double,_ y:Double,_ xx:Double,_ yy:Double,_ t:Double,_ c:NSColor) {
 line(x,y,xx,yy,c.withAlphaComponent(0.3),3)
 for i in 0..<4 {let p=(t*0.55+Double(i)/4).truncatingRemainder(dividingBy:1);oval(x+(xx-x)*p-5,y+(yy-y)*p-5,10,10,c)}
}
func drawOverview(_ t:Double) {
 NSGradient(colors:[navy,NSColor(calibratedRed:0.025,green:0.105,blue:0.14,alpha:1),navy])!.draw(in:NSRect(x:0,y:0,width:1920,height:1080),angle:25)
 brandStrip("EXASOL  /  BUILT FOR ANALYTICAL QUESTIONS")
 for i in 0..<10 {let p=NSBezierPath(ovalIn:NSRect(x:1190+Double(i)*35+sin(t*0.2)*20,y:-460+Double(i)*15,width:1000,height:1000));teal.withAlphaComponent(0.035).setStroke();p.lineWidth=2;p.stroke()}
 brandLogo(80,42,31);text("BUILT FOR ANALYTICAL QUESTIONS",1220,49,23,muted,650)
 line(80,99,1840,99,muted.withAlphaComponent(0.18),1)
 let start:Double=t<5 ? 0:t<9 ? 5:t<21 ? 9:t<28 ? 21:t<36 ? 28:t<41 ? 36:41
 let u=t-start, rise=45*(1-ease((t-start)/0.55))
 if t<5 {
  text("YOUR NEXT QUESTION",90,214+rise,103,.white,1740)
  if u>0.5 {text("SHOULD NOT WAIT.",90,363+40*(1-ease((u-0.5)/0.6)),114,teal,1740)}
  let qs=["Which customers drive revenue?","Which orders could lose money?","What should the team do next?"]
  for i in 0..<3 {if u>0.9+Double(i)*0.45 {text(qs[i],102,645+Double(i)*93,43,i==1 ? gold:.white,1700)}}
 } else if t<9 {
  text("MEET",90,200+rise,83,.white,1700)
  text("EXASOL.",80,296+rise,191,teal,1740)
  text("The analytics database.",99,581,64,.white,1720)
  text("Complex SQL. Dashboards. AI + ML.",101,743,49,gold,1710)
  text("Designed for analytical workloads and concurrent access.",104,871,33,muted,1710)
 } else if t<21 {
  let phase=min(2,Int(u/4))
  let title=["ONE QUERY. MANY NODES.","READ COLUMNS. WORK IN MEMORY.","COMBINE THE WORK. RETURN THE ANSWER."]
  text(title[phase],80,133,phase==2 ? 59:70,.white,1780)
  box(300,258,1320,97,panel,17);text("SQL query → optimizer → distributed execution",337,283,39,.white,1250)
  let xs=[150.0,750.0,1350.0]
  for i in 0..<3 {
   let x=xs[i]
   flow(960,365,x+210,444,u,teal)
   box(x,449,420,272,panel,22);text("NODE \(i+1)",x+27,467,27,teal,370)
   text("CPU + memory",x+27,519,35,.white,370)
   for j in 0..<7 {let on=phase>0 && (j==2 || j==5);box(x+30+Double(j)*50,586,32,82,on ? gold:teal.withAlphaComponent(0.2),5)
    for k in 0..<4 {line(x+35+Double(j)*50,601+Double(k)*17,x+56+Double(j)*50,601+Double(k)*17,on ? navy:teal.withAlphaComponent(0.25),2)}
   }
   text("Compressed columns",x+27,676,23,muted,370)
   flow(x+210,731,960,811,u,phase==2 ? gold:teal)
  }
  box(550,806,820,77,navy,14);text("PARTIAL RESULTS → ONE SQL RESULT",574,829,27,phase==2 ? gold:muted,780)
  let sub=["MPP distributes query work across cluster nodes.","Columnar access + compression + in-memory processing.","Automatic query optimization reduces manual tuning."]
  text(sub[phase],83,925,36,.white,1750)
  text("Simplified query flow • Persistent storage backs the in-memory processing.",85,991,21,muted,1740)
 } else if t<28 {
  text("MATCH THE ENGINE TO THE WORK.",80,145+rise,69,.white,1770)
  box(80,314,825,441,panel,23);box(955,314,885,441,panel,23)
  text("ROW-ORIENTED OLTP",113,347,36,muted,750)
  text("Create an order.\nUpdate a record.",113,424,55,.white,750)
  text("Suited to transactional access",113,656,29,muted,750)
  text("EXASOL ANALYTICS",988,347,39,teal,810)
  text("Scan. JOIN.\nAggregate at scale.",988,424,55,.white,810)
  text("Columnar + in-memory + MPP",988,656,32,teal,810)
  text("Read selected columns. Share query work. Tune automatically.",87,824,37,gold,1740)
  text("Workload fit, not a universal ranking. Other analytical databases share these techniques.",87,949,24,muted,1730)
 } else if t<36 {
  text("NOW PUT THE ENGINE TO WORK.",80,142+rise,70,.white,1770)
  let titles=["CONNECT","PREDICT","VISUALIZE"]
  let details=["Virtual Schemas","Python UDFs","SQL-powered dashboards"]
  let proof=["MongoDB + Exasol JOIN","scikit-learn called from SQL","Dash apps via dash-server"]
  for i in 0..<3 {let x=80+Double(i)*600;let p=ease((u-Double(i)*0.45)/0.6);box(x,335+30*(1-p),560,424,panel,23);text(String(format:"%02d",i+1),x+30,363,30,gold,500);text(titles[i],x+30,429,51,teal,500);text(details[i],x+30,532,29,.white,510);text(proof[i],x+30,644,25,muted,510)}
  text("See the SQL. Follow the data. Ask the next question.",88,846,41,.white,1730)
  text("AI access through MCP connects agents to the analytics workflow.",88,951,29,muted,1730)
 } else if t<41 {
  text("YOUR DATA. YOUR ENVIRONMENT.",80,147+rise,69,.white,1770)
  text("ON-PREM",93,385,64,teal,570);text("CLOUD",737,385,64,teal,510);text("HYBRID",1330,385,64,teal,510)
  line(100,521,1820,521,teal.withAlphaComponent(0.3),4)
  for i in 0..<12 {let p=(u*0.18+Double(i)/12).truncatingRemainder(dividingBy:1);oval(100+1720*p,515,12,12,gold)}
  text("Keep analytical execution where your requirements need it.",99,653,42,.white,1720)
  text("SQL analytics  /  In-database ML  /  Agent access",101,823,39,muted,1710)
 } else {
  text("BRING A HARD QUESTION.",90,223+rise,87,.white,1740)
  text("LET’S RUN THE SQL.",90,399+rise,103,teal,1740)
  box(100,675,1710,132,teal,17);text("MEET THE ENGINEERS AT THE EXASOL BOOTH",137,717,42,navy,1650)
  text("Watch the demos: JOIN data → run a model → build a dashboard",103,901,34,.white,1710)
 }
 box(80,1043,1760,3,muted.withAlphaComponent(0.15),1);box(80,1043,1760*t/45,3,teal,1)
 if u<0.28 && t>0.1 {let p=ease(u/0.28);box(1920*p,110,1920*(1-p),900,navy,0)}
 if t>44.6 {box(0,0,1920,1080,navy.withAlphaComponent((t-44.6)/0.4),0)}
}
func previousDraw(_ t:Double) {
 box(0,0,1920,1080,navy,0)
 let bg=NSGradient(colors:[navy,NSColor(calibratedRed:0.075,green:0.075,blue:0.16,alpha:1),navy])!
 bg.draw(in:NSRect(x:0,y:0,width:1920,height:1080),angle:25)
 brandStrip("EXASOL  /  ENGINEER TO ENGINEER")
 for i in 0..<5 {let path=NSBezierPath(ovalIn:NSRect(x:1240+Double(i)*46+sin(t*0.2)*15,y:-530+Double(i)*22,width:1000,height:1000));teal.withAlphaComponent(0.045).setStroke();path.lineWidth=1.5;path.stroke()}
 line(80,99,1840,99,muted.withAlphaComponent(0.15),1)
 for i in 0..<24 { let x=(Double(i*137)+t*17).truncatingRemainder(dividingBy:1920);let y=Double((i*191)%1080);oval(x,y,3,3,teal.withAlphaComponent(0.23)) }
 brandLogo(80,42,32)
 text("ENGINEER TO ENGINEER  /  VIRTUAL SCHEMAS",1110,53,20,muted,750)
 let scene=min(5,Int(t/8)), local=t-Double(scene*8)
 let entry=min(1,local/0.55);let offset=24*pow(1-entry,3)
 text(headings[scene],80,119+offset,61,.white,1800)
 box(80,219,74,5,teal,2)
 if scene == 3 || scene == 4 {
  // Keep the complete query and the complete result visible together, like the source.
  box(80,264,1030,532,panel,20)
  box(1130,264,710,406,panel,20)
  box(80,231,235,30,teal,7);text("FULL SQL QUERY",95,234,18,navy,240)
  box(1130,221,225,34,teal,7);text("FROM MONGODB",1145,225,18,navy,235)
  box(1610,221,230,34,gold,7);text("FROM EXASOL",1630,225,18,navy,230)
  let n = scene == 4 ? sql.count : min(sql.count,Int(max(0,local)*190))
  text(String(sql.prefix(n)),107,295,27,.white,987,true)
  text("MONGO_CITY",1151,287,20,teal,240,true)
  text("MONGO_TIER",1380,287,20,teal,200,true)
  text("EXASOL_REVENUE",1600,287,20,gold,240,true)
  let rows = [("Hyderabad","Silver","1,086,700"),("Ahmedabad","Gold","1,065,615"),("Hyderabad","Gold","1,029,700"),("Kochi","Gold","1,011,870"),("Kochi","Silver","960,570")]
  for (i,r) in rows.enumerated() {
   let y=345+Double(i)*62
   line(1148,y-16,1822,y-16,muted.withAlphaComponent(0.18),1)
   if scene == 4 || local>3.6+Double(i)*0.3 {
    text(r.0,1151,y,26,teal,240,true);text(r.1,1380,y,26,teal,200,true);text(r.2,1658,y,26,gold,180,true)
   }
  }
  text("MongoDB customer attributes + Exasol revenue",1145,699,23,muted,690)
  text("Original demo query and result",1145,748,21,muted,690)
  NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current!.cgContext.translateBy(x:147,y:851);NSGraphicsContext.current!.cgContext.scaleBy(x:0.55,y:0.55);engineer(0,0,true,local<2.2,t);NSGraphicsContext.restoreGraphicsState()
  NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current!.cgContext.translateBy(x:1742,y:851);NSGraphicsContext.current!.cgContext.scaleBy(x:0.55,y:0.55);engineer(0,0,false,local>=2.2,t);NSGraphicsContext.restoreGraphicsState()
  box(235,845,700,135,panel,18);text("MAYA",256,858,17,teal,200);text(questions[scene],256,888,27,.white,650)
  box(965,845,680,135,panel,18);text("DEV",988,858,17,gold,200)
  text(local>2.2 ? answers[scene] : "•  •  •",988,888,27,.white,635)
  for i in 0..<6 {box(790+Double(i)*57,1032,40,4,i<=scene ? teal:panel,2)}
  return
 }
 // Distinct illustrated engineers stay visible throughout the conversation.
 engineer(215,681,true,local<3.5,t)
 engineer(1705,681,false,local>=3.5,t)
 text("MAYA",156,953,23,teal,200)
 text("Data engineer",124,987,18,muted,230)
 text("DEV",1670,953,23,gold,200)
 text("Platform engineer",1618,987,18,muted,250)
 box(80,286+offset,760,148,panel,24)
 box(80,286+offset,5,148,teal,2)
 text(questions[scene],112,309+offset,34,.white,695)
 if local>2.2 {
  let dy=18*pow(1-min(1,(local-2.2)/0.4),3)
  box(1080,286+dy,760,148,panel,24);box(1835,286+dy,5,148,gold,2)
  text(answers[scene],1112,309+dy,34,.white,695)
 } else { text("•  •  •",1120,330,35,gold,500) }
 if scene == 0 || scene == 1 || scene == 2 {
  let sy=scene == 2 ? 540.0:575.0
  box(421,sy,320,190,panel,24);text("MongoDB",455,sy+27,34,teal,290);text("Customers\nCity + loyalty tier",455,sy+88,25,muted,290)
  box(1179,sy,320,190,panel,24);text("Exasol",1213,sy+27,34,gold,280);text("Orders\nRevenue",1213,sy+88,25,muted,270)
  line(755,sy+95,1165,sy+95,teal.withAlphaComponent(0.4),4)
  for i in 0..<5 {let p=(t*0.3+Double(i)/5).truncatingRemainder(dividingBy:1);oval(755+p*400,sy+89,12,12,teal)}
  box(808,sy+52,304,84,navy,14);text(scene==0 ? "ONE QUESTION" : "VIRTUAL SCHEMA",832,sy+80,23,.white,280)
  text(scene==0 ? "What drives revenue across our customer base?" : scene==1 ? "Connect → query → combine" : "MongoDB data → virtual tables → SQL",450,817,32,.white,1120)
  if scene==2 {text("The source data stays in MongoDB.",590,877,24,muted,850)}
 } else if scene == 3 {
  box(397,473,1126,481,panel,24)
  oval(424,497,11,11,teal);text("SQL  /  JOIN EXTERNAL + LOCAL DATA",450,489,18,muted,900)
  let n=min(sql.count,Int(max(0,local-0.25)*210))
  text(String(sql.prefix(n)),428,534,25,teal,1070,true)
 } else if scene == 4 {
  box(419,490,1082,418,panel,24)
  text("CITY",459,521,21,teal,350);text("TIER",873,521,21,teal,230);text("REVENUE",1195,521,21,gold,280)
  let rows = [("Hyderabad","Silver","1,086,700"),("Ahmedabad","Gold","1,065,615"),("Hyderabad","Gold","1,029,700"),("Kochi","Gold","1,011,870"),("Kochi","Silver","960,570")]
  for (i,r) in rows.enumerated() {if local>Double(i)*0.35+0.4 {let y=577+Double(i)*59;line(451,y-9,1467,y-9,muted.withAlphaComponent(0.15),1);text(r.0,459,y,28,.white,390);text(r.1,873,y,28,teal,250);text(r.2,1195,y,28,gold,270,true)}}
  text("Illustrative result from the source demo",669,937,19,muted,800)
 } else {
  text("Two sources.",478,495,76,.white,1050)
  text("One SQL conversation.",478,588,76,teal,1300)
  box(480,727,960,108,teal,20);text("SEE VIRTUAL SCHEMAS IN ACTION",528,757,34,navy,930)
  text("Ask questions. Explore the query. Meet the engineers.",480,874,27,muted,1030)
 }
 for i in 0..<6 {box(790+Double(i)*57,1032,40,4,i<=scene ? teal:panel,2)}
 // Same background at either end gives the loop a clean visual reset.
 let fade=min(1,min(t/0.4,(48-t)/0.5))
 if fade<1 {box(0,0,1920,1080,navy.withAlphaComponent(1-fade),0)}
}

if CommandLine.arguments.contains("--preview") {
 for sec in (CommandLine.arguments.contains("--dashboard") ? [3.0,6.0,11.0,15.0,20.0,25.0,30.0,36.0,39.0,45.0,52.0,64.0,72.0] : [3.0,6.0,11.0,15.0,20.0,25.0,30.0,36.0,39.0,45.0]) {
  let rep=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:W,pixelsHigh:H,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.deviceRGB,bytesPerRow:W*4,bitsPerPixel:32)!
  NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(bitmapImageRep:rep)
  let ctx=NSGraphicsContext.current!.cgContext;ctx.translateBy(x:0,y:1080);ctx.scaleBy(x:1,y:-1)
  NSGraphicsContext.current=NSGraphicsContext(cgContext:ctx,flipped:true);draw(sec)
  NSGraphicsContext.restoreGraphicsState()
  let prefix=CommandLine.arguments.contains("--overview") ? "overview-preview":CommandLine.arguments.contains("--dashboard") ? "dashboard-preview":CommandLine.arguments.contains("--udf") ? "udf-preview":"preview"
  try rep.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"booth-video/\(prefix)-\(Int(sec)).png"))
 }
 exit(0)
}
let writer = try AVAssetWriter(outputURL:URL(fileURLWithPath:out),fileType:.mp4)
let input = AVAssetWriterInput(mediaType:.video,outputSettings:[AVVideoCodecKey:AVVideoCodecType.h264,AVVideoWidthKey:W,AVVideoHeightKey:H,AVVideoCompressionPropertiesKey:[AVVideoAverageBitRateKey:8_000_000,AVVideoMaxKeyFrameIntervalKey:60,AVVideoProfileLevelKey:AVVideoProfileLevelH264HighAutoLevel]])
let adaptor=AVAssetWriterInputPixelBufferAdaptor(assetWriterInput:input,sourcePixelBufferAttributes:[kCVPixelBufferPixelFormatTypeKey as String:kCVPixelFormatType_32ARGB,kCVPixelBufferWidthKey as String:W,kCVPixelBufferHeightKey as String:H,kCVPixelBufferCGImageCompatibilityKey as String:true,kCVPixelBufferCGBitmapContextCompatibilityKey as String:true])
writer.add(input);writer.shouldOptimizeForNetworkUse=true
guard writer.startWriting() else {fatalError("start: \(String(describing:writer.error))")};writer.startSession(atSourceTime:.zero)
for frame in 0..<(fps*seconds) {
 while !input.isReadyForMoreMediaData {if writer.status == .failed {fatalError("writer: \(String(describing:writer.error))")};Thread.sleep(forTimeInterval:0.005)}
 autoreleasepool {
  var pb:CVPixelBuffer?;CVPixelBufferPoolCreatePixelBuffer(nil,adaptor.pixelBufferPool!,&pb)
  let pixel=pb!;CVPixelBufferLockBaseAddress(pixel,[])
  let ctx=CGContext(data:CVPixelBufferGetBaseAddress(pixel),width:W,height:H,bitsPerComponent:8,bytesPerRow:CVPixelBufferGetBytesPerRow(pixel),space:CGColorSpaceCreateDeviceRGB(),bitmapInfo:CGImageAlphaInfo.noneSkipFirst.rawValue)!
  ctx.translateBy(x:0,y:CGFloat(H));ctx.scaleBy(x:1,y:-1)
  NSGraphicsContext.saveGraphicsState();NSGraphicsContext.current=NSGraphicsContext(cgContext:ctx,flipped:true)
  draw(Double(frame)/Double(fps));NSGraphicsContext.restoreGraphicsState()
  CVPixelBufferUnlockBaseAddress(pixel,[])
  if !adaptor.append(pixel,withPresentationTime:CMTime(value:Int64(frame),timescale:Int32(fps))) {fatalError("append: \(String(describing:writer.error))")}
 }
 if frame%240==0 {print("Rendered \(frame/fps)/\(seconds)s");fflush(stdout)}
}
input.markAsFinished();let sem=DispatchSemaphore(value:0);writer.finishWriting{sem.signal()};sem.wait()
guard writer.status == .completed else {fatalError("finish: \(String(describing:writer.error))")}
print("DONE",out)
