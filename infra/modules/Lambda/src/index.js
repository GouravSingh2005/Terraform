const AWS = require("aws-sdk");
const sharp = require("sharp");

const s3 = new AWS.S3();

const getMimeTypeFromKey = (key) => {
  const extension = key.split(".").pop().toLowerCase();

  switch (extension) {
    case "jpeg":
    case "jpg":
      return "image/jpeg";
    case "png":
      return "image/png";
    case "webp":
      return "image/webp";
    case "gif":
      return "image/gif";
    default:
      return "application/octet-stream";
  }
};

exports.handler = async (event) => {
  const inputPrefix = process.env.INPUT_PREFIX || "uploads/";
  const outputPrefix = process.env.OUTPUT_PREFIX || "resized/";
  const resizeWidth = Number(process.env.RESIZE_WIDTH || 1200);

  for (const record of event.Records || []) {
    const bucket = record.s3.bucket.name;
    const rawKey = decodeURIComponent(record.s3.object.key.replace(/\+/g, " "));

    if (!rawKey.startsWith(inputPrefix)) {
      continue;
    }

    const outputKey = `${outputPrefix}${rawKey.slice(inputPrefix.length)}`;

    const sourceObject = await s3.getObject({
      Bucket: bucket,
      Key: rawKey,
    }).promise();

    const outputBuffer = await sharp(sourceObject.Body).resize({
      width: resizeWidth,
      withoutEnlargement: true,
      fit: "inside",
    }).toBuffer();

    await s3.putObject({
      Bucket: bucket,
      Key: outputKey,
      Body: outputBuffer,
      ContentType: sourceObject.ContentType || getMimeTypeFromKey(rawKey),
      CacheControl: "public, max-age=31536000, immutable",
    }).promise();
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ ok: true }),
  };
};