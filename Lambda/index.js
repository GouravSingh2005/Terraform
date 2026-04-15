import { S3Client, GetObjectCommand, PutObjectCommand } from "@aws-sdk/client-s3";
import sharp from "sharp";
import Redis from "ioredis";


const s3 = new S3Client({ region: "ap-southeast-1" });


const redis = new Redis({
  host: process.env.REDIS_HOST,
  port: process.env.REDIS_PORT,
});


const streamToBuffer = async (stream) => {
  const chunks = [];
  for await (let chunk of stream) chunks.push(chunk);
  return Buffer.concat(chunks);
};

export const handler = async (event) => {
  try {
    const record = event.Records[0];

    const bucket = record.s3.bucket.name;
    const key = decodeURIComponent(record.s3.object.key);

    console.log(" New image:", key);

 
    const cached = await redis.get(key);
    if (cached) {
      console.log("⚡ Already processed (cached)");
      return;
    }

    
    const getCommand = new GetObjectCommand({
      Bucket: bucket,
      Key: key,
    });

    const data = await s3.send(getCommand);
    const imageBuffer = await streamToBuffer(data.Body);

  
    const resizedImage = await sharp(imageBuffer)
      .resize(300, 300)
      .toBuffer();

    const newKey = `resized/${key}`;

  
    await s3.send(
      new PutObjectCommand({
        Bucket: bucket,
        Key: newKey,
        Body: resizedImage,
        ContentType: "image/jpeg",
      })
    );


    await redis.set(key, "done");

    console.log("Image resized & uploaded:", newKey);

  } catch (err) {
    console.error(" Error:", err);
    throw err;
  }
};