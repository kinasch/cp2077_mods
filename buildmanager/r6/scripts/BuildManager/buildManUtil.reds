@addMethod(PlayerDevelopmentData)
public final const func GetBoughtPerks() -> array<SPerk> {
	let count: Int32 = ArraySize(this.m_perkAreas);
    let i: Int32 = 0;
	let allBoughtPerks: array<SPerk>;
    while i < count {
		let j: Int32 = 0;
		let perkCount: Int32 = ArraySize(this.m_perkAreas[i].boughtPerks);
		while j < perkCount {
			ArrayPush(allBoughtPerks,this.m_perkAreas[i].boughtPerks[j]);
			j += 1;
		}
		i += 1;
	}
	return allBoughtPerks;
}