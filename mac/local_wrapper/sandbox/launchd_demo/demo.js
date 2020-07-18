const pad2Digits = (num) => String(num).padStart(2, "0");
const timestamp = () => {
  const now = new Date();
  return (
    "[" +
    pad2Digits(now.getHours()) +
    ":" +
    pad2Digits(now.getMinutes()) +
    ":" +
    pad2Digits(now.getSeconds()) +
    "]"
  );
};

console.log(timestamp(), "<== There should be a 20 sec interval between 2 lines");
